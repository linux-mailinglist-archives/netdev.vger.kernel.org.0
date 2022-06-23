Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E3E558BD6
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiFWXoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiFWXog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:44:36 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E764FC6B;
        Thu, 23 Jun 2022 16:44:35 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id n14so408345ilt.10;
        Thu, 23 Jun 2022 16:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Q9dyH1c/WKyQejLN3Yo4vHJr2Mjmed9KfkMox7OYbHw=;
        b=Y8r6pVrW3fnhs0FmOm3bz1xp8USIwC8ve01v9J6QV4g9KA5Uf4F2vDivQiIYNojmIs
         U7E3kJe2r9Z6oSOjcsyIFuSCJ1VrRdC2Jw3puIyxHpgXeOaSuy1+pE0nYvEGjekaVpaA
         fcm8wrPrPGTo9LokkV0nz1qrxaCs/NL/3/fvxdV3hJJMEe3wrve5velwn3dJTTDky17x
         KOsBTZb/1Z7bWLeXM8+uusUi7+7WhzBswPteztfYZnwf+NKtNaUXjQBeslPq/u2D8rVE
         +eFC+cOK4qXKDW4EVhfoTb2viliPYy3uN8w6cBCCtuheF6awJp0haifDMnfYbk+paiG8
         Lsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Q9dyH1c/WKyQejLN3Yo4vHJr2Mjmed9KfkMox7OYbHw=;
        b=mr9ELWY4szgIRoxADSiP0OODcIrqkHFdyM6+tk/WQV4AT608IeIQti1tZ645KvVk4+
         VF9qui1WONFO7nokJD0X6UuoDH3DxgF0CUk0S5Zlrn8RDVdyAvEm8C1NkOPu/Tqpodys
         GuPH8OLpIB6dGmGBpgBAGV9/uDKAM1oB+/Qafw6tWjYAzbXAigoAW4czhdikfKvwIT4B
         U5+LAEdEwcZfxhO10/CtDvJ3SS3ubfh8DuC3iueADBhkBbW86E2XRlvLE5OgamvjJHvs
         hQHWgH5pKIVHl0FU6103hv1rt6cXVDh2o7Y7mqAkEJUZIi/wVNOmdjviHygonCn7Wkmr
         P6MQ==
X-Gm-Message-State: AJIora9teySOd1nT5U/UvyrqN0LFU+r6gp/hbTitPGoC+l6Tdk6NC7JC
        0VLt4lX5KjwM+gpqttfiPCA=
X-Google-Smtp-Source: AGRyM1uAMrbwKWLgODvFzmC0vmX8VqGiUp8rWPxrkbPQuXToUKxA2kE76dkWkLpDWSUW7wErwn2qPQ==
X-Received: by 2002:a05:6e02:154e:b0:2d9:3a5:3c61 with SMTP id j14-20020a056e02154e00b002d903a53c61mr6591762ilu.147.1656027875171;
        Thu, 23 Jun 2022 16:44:35 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id n41-20020a056602342900b00669536b0d71sm430920ioz.14.2022.06.23.16.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 16:44:34 -0700 (PDT)
Date:   Thu, 23 Jun 2022 16:44:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Simon wang <wangchuanguo@inspur.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Wang <wangchuanguo@inspur.com>
Message-ID: <62b4fadc6aaf_26268208bf@john.notmuch>
In-Reply-To: <20220622031923.65692-1-wangchuanguo@inspur.com>
References: <20220622031923.65692-1-wangchuanguo@inspur.com>
Subject: RE: [PATCH] bpf: Replace 0 with BPF_K
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon wang wrote:
> From: Simon Wang <wangchuanguo@inspur.com>
> 
> Enhance readability.
> 
> Signed-off-by: Simon Wang <wangchuanguo@inspur.com>
> ---
>  kernel/bpf/verifier.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2859901ffbe3..29060f15daab 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9064,7 +9064,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
>  
>  	if (opcode == BPF_END || opcode == BPF_NEG) {
>  		if (opcode == BPF_NEG) {
> -			if (BPF_SRC(insn->code) != 0 ||
> +			if (BPF_SRC(insn->code) != BPF_K ||
>  			    insn->src_reg != BPF_REG_0 ||
>  			    insn->off != 0 || insn->imm != 0) {
>  				verbose(env, "BPF_NEG uses reserved fields\n");
> -- 
> 2.27.0
> 

Code is fine and seems everywhere else we do this check with

    BPF_SRC(insn->code) != BPF_K

One thing though this should have [PATCH bpf-next] in the title so its
clear the code is targeted for bpf-next. Although in this case its
obvious from the content.

Acked-by: John Fastabend <john.fastabend@gmail.com>
