Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAA662E21C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiKQQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbiKQQgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:36:33 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB846206A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:35:40 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id k7so2106781pll.6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqWtwUL+XfqGYYUdjIjLArYbm8wXlzt968/7FqxybFQ=;
        b=FEvirZFAUR5YKO20VMQmhw9zSjTlDPU/wMNABbH5hNSDYSaGARUfBpdAwHoyPsY2dF
         gyUKBKRqPjODCnDGVOG+SCemh/jRi4dOw5kYJFrTHdPwycGlnUojdM7NkSITAuv0cAnT
         M03VbJPDnX6JggHF2X9tn36MvcyBsc4N+j2t+Jel6PQweYgE+b9CEQcMUQ+EX2WXqT1d
         baAvPgWHnI9VuiDMs509oaaaKzVv4MpZiMerDi3IUAi6Fn0Q2FsF9QZVklsNQYQUQu6x
         JR8n7eQrH39PeH0FjNBGGnDlZVxfWT6QR8AU2ky88bjg6ozmm4mpSWULp4m6faNWl+/Y
         kOSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oqWtwUL+XfqGYYUdjIjLArYbm8wXlzt968/7FqxybFQ=;
        b=chGwo0O55SkGlw4Sls2v7H3ZIT1s8DMxnqHe81c0D//CNv1vbDE4ktCIZs0EhnmyLI
         Y5o1i3dxSVDyCKA97TU6Spol5A0yuLQS822bKQOLAvp0+bLhGIYBqI82y1JMA6RzvcN7
         S6GD7y8ZZP4UiSuYT9M5A8MCKZkS40UP4CupUXyENwv7Tt1tqO04lO2QrPjfSeOqZCCy
         TIWLNj1vNCGsM8yZE/FeDydOwoBaF9Futthn/s+x97sM4InvPXi30m3rD2IXcgfvgZB3
         cgL19G5FH3eKWm9YKAQYP9nJqPqcYeUnkpr+5eQILSTjYL22Oa+qRfFDN2q2IOuUMFam
         rP1w==
X-Gm-Message-State: ANoB5pkL2yeEWTh4MH6zzU0B5FQsII7wX+aTXk+o3VfmHysrmISGcAsG
        /ZYjMlwoopt1vsiUubk2Youm0Q==
X-Google-Smtp-Source: AA0mqf4ZHC/cy3v13ZI3GFz18URhxXLw1N0In4WmQ0Xbao0hPVke3N4mw50IF8GRWZmpFs6Z3C98kw==
X-Received: by 2002:a17:903:2306:b0:188:f9c3:eb03 with SMTP id d6-20020a170903230600b00188f9c3eb03mr628463plh.20.1668702940443;
        Thu, 17 Nov 2022 08:35:40 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j8-20020a170902da8800b00176ba091cd3sm1604035plx.196.2022.11.17.08.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 08:35:40 -0800 (PST)
Date:   Thu, 17 Nov 2022 08:35:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Lai Peter Jun Ann <jun.ann.lai@intel.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH iproute2-next v1] tc_util: Fix no error return when
 large parent id used
Message-ID: <20221117083537.6aceb759@hermes.local>
In-Reply-To: <1668663197-22115-1-git-send-email-jun.ann.lai@intel.com>
References: <1668663197-22115-1-git-send-email-jun.ann.lai@intel.com>
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

On Thu, 17 Nov 2022 13:33:17 +0800
Lai Peter Jun Ann <jun.ann.lai@intel.com> wrote:

> This patch is to fix the issue where there is no error return
> when large value of parent ID is being used. The return value by
> stroul() is unsigned long int. Hence the datatype for maj and min
> should defined as unsigned long to avoid overflow issue.
> 
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>

Yes, looks good. Will apply to main.
What about qdisc_handle as well?
