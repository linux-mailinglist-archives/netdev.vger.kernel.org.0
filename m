Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B8668C77
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbjAMGW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjAMGVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:21:11 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3930C6A0C4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:20:45 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q64so21462496pjq.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bb8kAgCczDlEY+vZt/35rHBWlEyiMKKOzfZ441cocKg=;
        b=RxBIiJ6ZU+wYYkG3TRjRNYZZ4n9gayV8YLs7QFTuoZh2ouqra99k8Vt79BBR+FiJLd
         nrprWTB1nWw7XGxDQ6rZ0ycPJPBSYMPbHsd7Po5+o4m/6S3RgAPsEN3YlRLfOd32kpSa
         5C6TmDdqms60L+/QGYv8aHX8cwZ3uxVZ57ir/mAe3hvwOuw1mFGAqRNfiV62nwWQlS1b
         3jpQElQM/HC7YWrKyylmuSNo14cYoSQQRSBZLb1IN6LrYNduu0lU2gYlaIg313HnMJw8
         L/8dO9mTb0sDuSZIYcS6rbZtv6IEBJ/2tWR5z0KKHEso2nztLQbJjDssGoTmJfHY/npx
         HQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bb8kAgCczDlEY+vZt/35rHBWlEyiMKKOzfZ441cocKg=;
        b=ix2XDz+gHHGJ5fITChHkZIaX7WavcVYGwnV9MwQvW8E7hEnAO0wzYeIc5nKs1xTKa2
         AQEELnNfKNzhCSr0VFJz/qRmO3UQJQnNxsFNADA0VjR7CBOzu6F2Y+pdPwFhKMV59OaI
         ZqXLM84FTiAbANjZagkxoiMqp9Zu0tKloVB/QjDJzFeZuN/QHrmYTR+UPM6Wz0RNkawe
         bqUb4dvb0yjdDVbt8BHw0ROxIiLBahVwoInV4F0AfN3YmRw8/VQS90n7VIPeS3SF/3Ii
         t8xIgnE8enXPZ8ylMByrVz8NTBMsFgqvyxrgUYKGsAde9jDnBsMwzSMgjPAd4nXe+nGA
         h2UQ==
X-Gm-Message-State: AFqh2kr5VpmRi4SkGojqbSAYAa3PknDW+DZKP0tnYWpZ0G762XRuqG80
        VkZwFyla3Qc/ZsWQOwUaGYBWy/njP0r2H4jc
X-Google-Smtp-Source: AMrXdXvV2f2sX4+Fd0s7UTr+EtY+1+RnzMAZlm1tGJAuLkqP9+lh0H5jl63ufqjdG2LGZRuo9rI4nA==
X-Received: by 2002:a17:902:f1d2:b0:194:4335:5389 with SMTP id e18-20020a170902f1d200b0019443355389mr10563971plc.35.1673590845090;
        Thu, 12 Jan 2023 22:20:45 -0800 (PST)
Received: from Laptop-X1 ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b0018941395c40sm13087232plh.285.2023.01.12.22.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 22:20:44 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:20:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Message-ID: <Y8D4NhoRnAIz7XBX@Laptop-X1>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com>
 <20230113034617.2767057-2-liuhangbin@gmail.com>
 <20230112203019.738d9744@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112203019.738d9744@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 08:30:19PM -0800, Stephen Hemminger wrote:
> On Fri, 13 Jan 2023 11:46:17 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > 	if (tb[TCA_EXT_WARN_MSG]) {
> > +		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> > +		print_nl();
> > +	}
> > +
> 
> Errors should go to stderr, and not to stdout. And no JSON support please.

Thanks, I thought this belongs to an attr data. So I put it in the JSON object.
I will adjust this to stderr and out side of JSON.

Hangbin
