Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8EA4C33AC
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiBXR2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiBXR1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:27:51 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A3B1C0273
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:27:21 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id w27so5122280lfa.5
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=8RGf8KCAQJHNAosPeJyYSXlvMYaIyXQSQxyPYx24e/w=;
        b=O9kj/5BfkMHLPyNzZggPZMcEllgF7boU/xWS+3IYd2iSn6L8RaPQ2dY0Txd0Izp/m9
         JU81TlQz21RM0gebie4vMoqbc+qcFCtrE143rAm1rNhopoj2FkINwGh49JwTO18Uam2f
         fTc5kdQzJULFnrkBjig0O4d3NpkujtX4PSiDc604XC581t2YxQFoGzHiiw3/aSBcWXwr
         dv9tu5aE4de/62/Kv+r85Ef3WcEIr8EIjg5LhJsqGVylofJ6547h4sJjTKcjYjkm5TRR
         3Qzz/YLOfaZ5O0M6Hr0w+zQx5p6h2WA+v8C8sKmqRvPsc10Kmg0dVw9BKAs2MJbPfcMa
         3tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8RGf8KCAQJHNAosPeJyYSXlvMYaIyXQSQxyPYx24e/w=;
        b=GqerT+3DoqBvq6dfulK4+KLqBEdFSN5lvBYlHbRp4t1t3oNnsL1kyjFVKqV8nB9QvE
         J3vUJIMmI7Rfe6adSN0cO5tv8Ik9IoNS1oiT/IVrWQiMTX7O7yTwir5p6pYtNuNxqVv4
         A0qQ3cPwfRL5AwwbGeV/zSPf0rd3M2FR3Hfj5+6e0pIKGq9Zbk9Bx4N06YPzCe7IkJpf
         9mqvsoAJ+cQMCWah8woOYA07YGi2XA/qkwZWxCztnNcW+Zv0XJZLruj8YD+1eyOQ+RgM
         pCvVQugCKh4HDLhyDGVpMlVYiVirLbDUb3QPgfdg8HGzUByBcqmuYqL8vmhNMNQBDZ27
         POcQ==
X-Gm-Message-State: AOAM533XhM8iJayol/LuXFcz0faOFsuItk0lkOsbSa0A6FOE/Nem11Jq
        BDA7lGAsdxgIx08fbDe904BZo4aY3gPytw==
X-Google-Smtp-Source: ABdhPJxi0EDgD7FVpqCxykEIc6TjWq/KNHAqX7KNH4DXB+VOLRwpNHxQYabt/wS0O4Q+sd83zlgVhQ==
X-Received: by 2002:ac2:4d91:0:b0:443:127b:558a with SMTP id g17-20020ac24d91000000b00443127b558amr2521316lfe.542.1645723639168;
        Thu, 24 Feb 2022 09:27:19 -0800 (PST)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id j2-20020a2e3c02000000b0024610e94b2fsm16961lja.130.2022.02.24.09.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 09:27:18 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1 net-next] net: bridge: add support for host l2 mdb entries
In-Reply-To: <20220224084806.4e85e6b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220223172407.175865-1-troglobit@gmail.com> <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org> <20220224080611.4e32bac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <875yp4qlcg.fsf@gmail.com> <20220224084806.4e85e6b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 24 Feb 2022 18:27:17 +0100
Message-ID: <8735k8qioa.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 08:48, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 24 Feb 2022 17:29:35 +0100 Joachim Wiberg wrote:
>> On Thu, Feb 24, 2022 at 08:06, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Thu, 24 Feb 2022 13:26:22 +0200 Nikolay Aleksandrov wrote:  
>> >> On 23/02/2022 19:24, Joachim Wiberg wrote:  
>>  [...]  
>> >> It would be nice to add a selftest for L2 entries. You can send it as a follow-up.  
>> > Let's wait for that, also checkpatch says you need to balance brackets
>> > to hold kernel coding style.  
>> Jakub, by "wait for that" do you mean you'd prefer I add the selftests
>> to this?
> Yes, add a selftest as a separate patch but in the same series.

OK, will do, thanks! :)

Regards
 /Joachim
 
