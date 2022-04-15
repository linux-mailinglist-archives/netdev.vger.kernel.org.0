Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC3502F48
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbiDOT1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbiDOT1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:27:07 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52A52F395
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 12:24:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h5so8260230pgc.7
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 12:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5OgH4mS1gyMYdyHSI3HJqkvI2lUD5gVsaIHAJDp01nM=;
        b=cxzbvOT0qTK8XipQE1T074UQEfiGs1VNnTqabZcONokavNDMoZOG8lE34jzqObOr7O
         c1Zk1/gbC/+bxXQU16EgzPtDaVtY8L434FzcBqCxc1nCVqLiCGUjvXHwHTSbZEp/Kz9V
         SD22l9MRTnjaaFrmiacwls6ndVhrc3xP183lWL+AB1l9LvfdLv+S3zm2EU3eOFy+a2Al
         ZKa6Rj5BQD0D8PJv4O8XnS35DPENSbFQO9Cgd+FDYZ1oiSg8O81Z5INc5kiGDOtIEtgz
         hASn044SrYdwDBfUjfAsPzFbUyGLA7hy/Mq5HsSnbCJw40mIW1cUObgdOyi1AiXvRWh4
         c2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5OgH4mS1gyMYdyHSI3HJqkvI2lUD5gVsaIHAJDp01nM=;
        b=Z8vZH6Dk1/7S9w4TgixFj+JkoPARp28VChiKOAeHdBiDzIb4NISmhBWm1KjQ42q7lj
         AiBippZe4KcM3FC1hh1h/mDNlwo0BHEb02TCLtHA0cRkHjtMqCYTmNjNKb6lvzYAV85R
         xUqcg/EJ58ObOo8+2WsaWc1BrahYG2WMaw6HExjRnQfZ4rHb8+9Hc8IiEdKLDrZqOkhy
         CsRZ0KZIz1N8KVaa9mtKVNUxyYk21ZSxcwLba3ksAASBAmhTlxuIKnSqmg5kqBJR/46I
         VQQ+xb4qcPKKcV+S+X39WObUh/lx40yutYLHJPKnG9gOSKt7f8tXuI8E4uiidDNv3IZx
         LyBg==
X-Gm-Message-State: AOAM530rBUAk8oe5HTJzNQVCkMKMSrLRYUKvvb3JfBNuEvcfs/2dbv31
        INfIvP9mkncy3iFfXlDYnSzISw==
X-Google-Smtp-Source: ABdhPJxsYvqomXXaPTuTPKUVeY42TQWd/8KoSM74H+qJKXQ9fNCYOaYb7TOpZm6prUVZ8K2Jpkpurw==
X-Received: by 2002:a63:1821:0:b0:39c:c771:dc2 with SMTP id y33-20020a631821000000b0039cc7710dc2mr366137pgl.507.1650050676405;
        Fri, 15 Apr 2022 12:24:36 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z14-20020a17090a170e00b001cb7e69ee5csm9330790pjd.54.2022.04.15.12.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:24:35 -0700 (PDT)
Date:   Fri, 15 Apr 2022 12:24:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v5 net-next 1/4] rtnetlink: return ENODEV when ifname
 does not exist and group is given
Message-ID: <20220415122432.5db0de59@hermes.local>
In-Reply-To: <20220415165330.10497-2-florent.fourcot@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
        <20220415165330.10497-2-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Apr 2022 18:53:27 +0200
Florent Fourcot <florent.fourcot@wifirst.fr> wrote:

>  	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
> -		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
> +		/* No dev found and NLM_F_CREATE not set. Requested dev does not exist,
> +		 * or it's for a group
> +		*/
> +		if (link_specified)
> +			return -ENODEV;

Please add extack error message as well?
Simple errno's are harder to debug.
