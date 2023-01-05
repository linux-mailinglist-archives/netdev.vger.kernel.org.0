Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2549765E7AB
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjAEJXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjAEJWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:22:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF6D551DA
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:22:30 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id w1so23371030wrt.8
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CQvrStphee7UCa3GgZYbkhyFMU5bJYCqmvyF3/ww0j0=;
        b=gH5pQ+qUH7ggP285A4mhD8drb3OG6Ja8sAsmrm2I5R7Dk8rRiyOccGG6XmgNcPFDsC
         /1432syE3PrL1EhCRoUNz2kZx7ysNfQ6JxwOs0d8/OxIT8VlDIxqR/3QvUp2tf6HQ+1h
         PlxehqBvBoe18H8Om/cAB8hkd0IAaIT93+HC6odQSXVv3yG0Ag/4XrV6NyGNSZ+7enqR
         VIPeRP5MTu9fh6eGOEn6GORFq8+u5cp6AnWcZ01QOeapvy6lQc6fJtnuMTwIgMcGp/T9
         M89kbOrnVy97l8q7DZ/YKZatAkkjlgjxxywmePcrJRAmQv/WNu9myTLjhsAuha3kVa+6
         xSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQvrStphee7UCa3GgZYbkhyFMU5bJYCqmvyF3/ww0j0=;
        b=02jSy5qZ4TJgDMV0zdynWIxiDlJFlas0xOMyApLbya/Bhp3yY3Y+l8r6tNfNqSmzw/
         nSCFD6uRvQ2HrSGWLvGrDKExPZwKr38wwrAC9e6byAfDpevoSLXRW3J2udiDvAbICM45
         qwQSrdxtOc6a9E+l0XCX2ugDXrp6KRSsSIfpSKQzbc4r1O2PdBlQKiOrFXdUghI9qb52
         U+uIBH3amTDm1+rNzmg2ZpqEoAC/IGbvoi3xB6PFeFnLt4mQqM/tcV5UxNenHMr2i65R
         ChTqySbieildTs/TmCcpYrQfuukpBQasCzyX7zfYaEjrnUe6lBJhmsmKf3iNWDBjfQjc
         ApJg==
X-Gm-Message-State: AFqh2kqSTqHT31Int5hIqG2IzkgIBDPgJOkmgFegnsXsBNGHTN/neQ1d
        xyyqgoEr0dU+MqNSCCG+Wqsmhw==
X-Google-Smtp-Source: AMrXdXs3xEGZNiq//j2zGJdG006QUVk5t5Bq9qMyk+zP5BYOlRanaDUL6pxpW6LOK0/2/8z6b5nT8Q==
X-Received: by 2002:adf:e19e:0:b0:298:879c:6d01 with SMTP id az30-20020adfe19e000000b00298879c6d01mr8357196wrb.23.1672910549066;
        Thu, 05 Jan 2023 01:22:29 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h15-20020adfaa8f000000b002421888a011sm36517785wrc.69.2023.01.05.01.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:22:28 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:22:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 10/15] devlink: restart dump based on devlink
 instance ids (simple)
Message-ID: <Y7aW02IvlYkoIS30@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-11-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-11-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:26AM CET, kuba@kernel.org wrote:
>xarray gives each devlink instance an id and allows us to restart
>walk based on that id quite neatly. This is nice both from the
>perspective of code brevity and from the stability of the dump
>(devlink instances disappearing from before the resumption point
>will not cause inconsistent dumps).
>
>This patch takes care of simple cases where state->idx counts
>devlink instances only.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

[...]


>+#define devlink_dump_for_each_instance_get(msg, state, devlink)		\
>+	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
>+					       &state->instance, xa_find)); \
>+	     state->instance++)

I'm still not happy about this to be honest, but I don't think it
matters now as it is cosmetical. I can try to address it in the
follow-up patch/set.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
