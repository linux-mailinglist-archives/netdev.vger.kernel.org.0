Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA364189E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 20:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLCTqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 14:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLCTqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 14:46:22 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9548A1DDF6;
        Sat,  3 Dec 2022 11:46:21 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id o12so5653389qvn.3;
        Sat, 03 Dec 2022 11:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kw32GtcdYT+/3M7KAcFKseRuBAPGHWVZRfO1RmOAVrQ=;
        b=MO9oOOjXlvvcYCfPnHhSUGW0EpetHuljZlJeTFNtKf7/VMKhCGvr0dK83AK2jFZzth
         PpUNjqw8QftBwQPhYZ9NJXlyJcZiEpVQVfYBR+X3qTp4ejBnQrkji2mfimV4Ht5Sw7JK
         hezMzwkwHdLPmEvKw+THShCMfnJMTyJwD+9LjJ8S7sX01mKcfNoaUjukiU2bbYO6EwJD
         hzs8K3ATKDKd5JG8cDF40BMPHXWGJmD3344iCK+HPtrOaVq6c9FDKfNRtHykrvEzaDFY
         klZM1JkNXo2AabLdSOUus3loArrrPBNtTOULXLj9ZRiZqrb7ukRULpdowWm815nRdw+E
         JqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kw32GtcdYT+/3M7KAcFKseRuBAPGHWVZRfO1RmOAVrQ=;
        b=vSeelhDWpb1FES4mOx6RYX/5Y9SyxV7IgdqQgFYngGSeQQ9em8ohGmV7hrx9ln06xI
         DhEUE6PVSBViIHscnTw3aAmbpfztjOlTXZfLrwS20EyAsRLXMViS5P4kFkyGlQ0nxQ1y
         qDPuAGb769Nfs/RATWlOkIp2aQ2knv+mBrZNZXSc3ZDyn9jZVtWighg0j51QoCqJoPrO
         tXY2XXrbKA97hYSuv7ZA6fgGZgZjFDJHZlnKKfIZPuyecL7IOlasckY0GlH6qI5rfqf3
         YZIWxT77FMFI/lFbd5khQX55Bbk0rYZo5NH7nLr2BSLEw/n1R1tTve0P4+HMnNlw7ZkD
         Z1NQ==
X-Gm-Message-State: ANoB5pkfZgLJLOydXc7zWLKUGtGo0j0qGGirhBgX0MeO7Pc+eUZLtXW0
        ThB1CczkVKDQAvSX0J6zhA4=
X-Google-Smtp-Source: AA0mqf7yGv1fep2limqh63esDr1KlIb2GrAgzVxJsFz97UJ1nKa1srUii1Bw4hv4F5WYE4QKq7LCGw==
X-Received: by 2002:a0c:f911:0:b0:4c7:4cb1:6754 with SMTP id v17-20020a0cf911000000b004c74cb16754mr6125691qvn.71.1670096780745;
        Sat, 03 Dec 2022 11:46:20 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:150b:cfdc:d3ab:f038])
        by smtp.gmail.com with ESMTPSA id b11-20020ac812cb000000b003a530a32f67sm24656qtj.65.2022.12.03.11.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 11:46:19 -0800 (PST)
Date:   Sat, 3 Dec 2022 11:46:18 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] net: sched: fix a error path in fw_change()
Message-ID: <Y4unik6y8a0MuoFt@pop-os.localdomain>
References: <20221201151532.25433-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201151532.25433-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:15:32PM +0800, Li Qiong wrote:
> The 'pfp' pointer could be null if can't find the target filter.
> Check 'pfp' pointer and fix this error path.

Did you see any actual kernel crash? And do you have a reproducer too?
Please include them if you do.

> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  net/sched/cls_fw.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
> index a32351da968c..b898e4a81146 100644
> --- a/net/sched/cls_fw.c
> +++ b/net/sched/cls_fw.c
> @@ -289,6 +289,12 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
>  			if (pfp == f)
>  				break;
>  
> +		if (!pfp) {
> +			tcf_exts_destroy(&fnew->exts);
> +			kfree(fnew);
> +			return err;


BTW, err is 0 here, you have to set some error here.

Thanks.
