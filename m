Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C692A50E535
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbiDYQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243272AbiDYQMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:12:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D6D3D4A7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:09:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p6so349198pjm.1
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TB2fpvDkBcSmdItFGFZ7RQb7sjfz3xFb/eIAVr3ICOQ=;
        b=6DRL7KY7nKkmVUuqLu7xdYMdMPKKyAASislBlGBna7f42TDvZl3HH0awbOcD2uLQzW
         YD92wCfNYUxFGrvpStEGnHWRrRkNNp8gqooOt0b7BiaImVkzcyPpJXpl4vZaMRnEP//i
         VnLFynqXWlu84FJCRhTYS17vCQr5Xi8FUGG58v4CMWW5167ufUhBnx74Jm1A5PjC3Ndb
         vfwcHHmOHwaRptEXcB6/F/dwndhFQhJaGTgIqSf6ZDMg4IbBa4431pjOjE3i92fAerwD
         CrrLTkJKUhajJFwleXvf8Vi+4hWJJDrMFaNvjrxvOD9JYadG7TYXxHTwkH9mU1mTJ3/z
         NJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TB2fpvDkBcSmdItFGFZ7RQb7sjfz3xFb/eIAVr3ICOQ=;
        b=M6xiEHuLDeaPZNkBO3fBOBeDZI75NMT0/d9ghhUmw+QzShGI9WkDSk0sgpObID+njz
         Z1DiisBIEXk/qBYA8bqBg12GdQ2IFwbLllaPi/5WRegLNhuwT+gfWXG9baRyfZ46i0QX
         GjvR5QAEg2TM8+77+jDNWJ8lbxbS8xO8dqi5gOfWVbkEQbhje9FoZ8pARUU4q5teAF5a
         WKnPeBZKexOvTfzH6iCv1j6Lmmj/NoE8DTE9EKWpGvqEOJ4sU5EYuOBeRtOoL/jslKhf
         0Rm3juUZKO3dAUNUlo+uKbjlTV34/bRX1YJOmCGRmNGB7p9VxZLZT/ejQGtl4tKJSSZ/
         CIfw==
X-Gm-Message-State: AOAM533KbNACfHvURCPtggiC2v/VMFYUsrlKkJTbTCe//fRqT2L+hzGC
        bNb5YPGgkqtgZKDsko8XK4+kcQ==
X-Google-Smtp-Source: ABdhPJwmqr4Y/N7HRg8t1FUAmsad5AdLualitHYCjQI9OAs18oSsgct4Cq1EsqEl22hh/GWWXd1Ihg==
X-Received: by 2002:a17:903:20d3:b0:15b:153c:6f79 with SMTP id i19-20020a17090320d300b0015b153c6f79mr18497390plb.157.1650902984545;
        Mon, 25 Apr 2022 09:09:44 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id cm11-20020a17090afa0b00b001d9738fdf2asm4558305pjb.37.2022.04.25.09.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 09:09:44 -0700 (PDT)
Date:   Mon, 25 Apr 2022 09:09:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        snelson@pensando.io
Subject: Re: [patch iproute2-next v2] devlink: introduce -h[ex] cmdline
 option to allow dumping numbers in hex format
Message-ID: <20220425090941.326d8ec8@hermes.local>
In-Reply-To: <20220425093036.1518107-1-jiri@resnulli.us>
References: <20220425093036.1518107-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 11:30:36 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

>  static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
>  {
> +	const char *num_fmt = dl->hex ? "%#x" : "%u";
> +	const char *num64_fmt = dl->hex ? "%#"PRIx64 : "%"PRIu64;

This is going to make it harder if/when format string properties are used.
Not sure what the better way is.
