Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A52D4BA79D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243983AbiBQSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:00:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243953AbiBQSA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:00:56 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71884172888
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:00:41 -0800 (PST)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 948D43F338
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645120839;
        bh=8WNVaa9QIfvt72Vl5TDc7E2L7AflK6TpXf5ep23Lgnk=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=LBw2oGbIz4PaT5kCx0OupMYHRGxKJFTGkas5QuOsNdXEKlcSU0sjvZCcpae9xqV3T
         IKotCMeHZJH07pd+5rETX3mW0Nj2n9+VUpE2JWfeldmLqhAS4aDKaWsyfY0Ojd7Mxl
         KnSzTeerNn6zlwDY7A6gKdZ/c1dFvBX1AS/sEtkNDaKD5533HKu+Cz+7FgZe+QwfGk
         3r28YxiUTxPFa9s807fD8xarahKuuXLR+kX89lVZonYOwLaqV+4jMIgqOJhCUddsPZ
         mRLUqD8rSOjmw0ieLOhjbNhrdwWPuDkD7CBgrlY1ydRoXDTFRQhTgUXm7S+BERmCCe
         b4HL+md+hOVPw==
Received: by mail-pj1-f69.google.com with SMTP id br11-20020a17090b0f0b00b001b90caa826fso4502570pjb.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:00:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=8WNVaa9QIfvt72Vl5TDc7E2L7AflK6TpXf5ep23Lgnk=;
        b=L36BirDEY2uCoVRq9bq9M22QSlDx2aVXerqAmL3aQ13eRwiUnGRSoaGiczliZTVhBx
         586BIX+BE2zDbdoKfzKguMVRVKCBP0myi6qmdokzaGe2DBLTFr2CPlzvfswIlPKbqVhF
         RfbnRQAmY2Y9b9Urh3GaIuqwo6HAU7xJ4RY1/tdLf5thmt5ZIWcwjiwumjbeBi5sjRL+
         CiXk1iWh0VLZt2QzhkO4AlNPVx5nTGgF7HgfDr5gvAntW2QCwsFxVyQ/0aB6z/sn4glz
         jblRcFZ7bNopL/12Ys7AASNAZrobk3qc1fGYgvwXLfSXzgTidfUE/vmXhgpnvNuSIwKy
         5qfQ==
X-Gm-Message-State: AOAM531XzuBk2tNT6qH36+sHj4HGy8CISEbcU08ljXi+GMBhtSHWkjQt
        v9vQ9oBBNlsc8sVY5cwYUs85qwmeGvqm0G+buXFrSsSb2nG0ashu1gG8Z6IrvSDe9dVvl6l7Toy
        O7E2pbFwwUv3lT7qI6lcQYblMqNTzlBTsHA==
X-Received: by 2002:a17:902:8645:b0:14d:5a0b:965e with SMTP id y5-20020a170902864500b0014d5a0b965emr3921996plt.112.1645120838299;
        Thu, 17 Feb 2022 10:00:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1QS0S27oAECKEFGMMbkfamgW6dWc+f6utA4qbXkBWmmZZ29bJTbGCElVRl9c1puivkaTOHA==
X-Received: by 2002:a17:902:8645:b0:14d:5a0b:965e with SMTP id y5-20020a170902864500b0014d5a0b965emr3921964plt.112.1645120838010;
        Thu, 17 Feb 2022 10:00:38 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id x14sm8529655pgc.60.2022.02.17.10.00.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Feb 2022 10:00:37 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 27C0C60DD1; Thu, 17 Feb 2022 10:00:37 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 210779FAC3;
        Thu, 17 Feb 2022 10:00:37 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
In-reply-to: <244dccd3-9c9d-0433-c341-ae17ee741a4e@redhat.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com> <20220216080838.158054-6-liuhangbin@gmail.com> <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com> <Yg2kGkGKRTVXObYh@Laptop-X1> <cc2e5a64-b53e-b501-4a08-92e087d52dda@gmail.com> <8863.1645071997@famine> <244dccd3-9c9d-0433-c341-ae17ee741a4e@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Thu, 17 Feb 2022 09:21:38 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15617.1645120837.1@famine>
Date:   Thu, 17 Feb 2022 10:00:37 -0800
Message-ID: <15618.1645120837@famine>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>On 2/16/22 23:26, Jay Vosburgh wrote:
>> David Ahern <dsahern@gmail.com> wrote:
>> 
>>> On 2/16/22 6:25 PM, Hangbin Liu wrote:
>>>> For Bonding I think yes. Bonding has disallowed to config via
>>> module_param.
>>>> But there are still users using sysfs for bonding configuration.
>>>>
>>>> Jay, Veaceslav, please correct me if you think we can stop using sysfs.
>>>>
>>>
>>> new features, new API only?
>> 	I'm in agreement with this.  I see no reason not to encourage
>> standardization on iproute / netlink.
>> 
>
>It was generally customary to include the iproute2 updates with the series
>as well. That way they all got merged at the same time. I do not see the
>needed iproute2 changes, is this still done?
>Seems like it would be a requirement now if no other configuration method
>is supported.

	Yes, the iproute2 support is required concurrently with new API
functionality.  That's not a new expectation.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
