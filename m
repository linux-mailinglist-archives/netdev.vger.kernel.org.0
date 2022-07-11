Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9E65705C3
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiGKOhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGKOhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:37:46 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C3665D7D
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:37:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d16so7266640wrv.10
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iJtfzfcC1AnsDV/pvGZu2fxxfQmMd6+WOUgRm2id0vA=;
        b=I0e3YydFgfpoaHWWDRkccW6qtvLN35SFDD/+T6Zf3YSIMWNNV3Mff+f6Xw61zVX2cs
         1uWFO47xJ8qdEm8xYURWHIZELaONyqchlS9wilP7b4oGmx9pxRIAyswMWZZvBk+smMZs
         yt12KfMRmGjE7ITc9L9FP7FjpGG+tPFOdmowu1VcdHgpplgc5wTqflQTOes3qwN03qrq
         eQVm0ExSbWAc4Rs5CMLNMlspn2+A8dO/qLPCZt/mPy0Zq5OQ1y8RZVetuvUzkDzMhtXK
         UlvFSooupOa8nvx5j/W5rUWkIdPIT7Phoh0fet6WUybKhUPjpAePCaRIYdnqI4FifzE2
         vNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iJtfzfcC1AnsDV/pvGZu2fxxfQmMd6+WOUgRm2id0vA=;
        b=fTj1Tpp1RZecVfwekgfAImNeTcMkqkcjb51gAUFMnpkTjpbKuK2RTGq4XY7JxtbSQi
         GSXGrNaPCOlHT+icNFR7NVLyAqnlQiH4Og0+oLQjzj11gdm46p7GT4/h7hsQ7oUQy0/K
         xEIgktDcF823eaCzS49x7DVSAtW9ulJ9g3Zqn3UtHpaaYYjAj+7kUNkj+pFwVvKR5GcA
         5SOkOe6WdpeRgrrOg1xfC2sCVXoPiTd+tbh8EEqeANqgjHgFYQRJDqrxR8foai4h98/A
         BXK1ImHq6tIHe9stIdOExAYlPEgTuHN3OoPAERe/3meq3OZapwStK32fnB70JwcP1ZC2
         q9UQ==
X-Gm-Message-State: AJIora/7n9AtJtJA4ji2X30VP1ynIrst0/Jdkl8uWaigkhc307O39b7I
        R5cVgmVcGsPC/Ob8JwFtnnkmaQ==
X-Google-Smtp-Source: AGRyM1t1yyqWZwS7XrcViX/JC5qBkc6Z05thqF1oYvTfe7VDmx7hhI7m+JnQqN9Z2J8tfLCknsoQtw==
X-Received: by 2002:adf:f38f:0:b0:21d:66b5:21c with SMTP id m15-20020adff38f000000b0021d66b5021cmr16896532wro.144.1657550264039;
        Mon, 11 Jul 2022 07:37:44 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id k5-20020a05600c1c8500b003974cb37a94sm10468691wms.22.2022.07.11.07.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 07:37:43 -0700 (PDT)
Date:   Mon, 11 Jul 2022 15:37:17 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH bpf-next v7 4/4] bpf, arm64: bpf trampoline for arm64
Message-ID: <Ysw1nSxQUghvY/eY@myrica>
References: <20220708093032.1832755-1-xukuohai@huawei.com>
 <20220708093032.1832755-5-xukuohai@huawei.com>
 <YswQQG7CUoTXCbDa@myrica>
 <4852eba8-9fd0-6894-934c-ab89c0c7cea9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4852eba8-9fd0-6894-934c-ab89c0c7cea9@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:16:00PM +0800, Xu Kuohai wrote:
> >> +	if (save_ret)
> >> +		emit(A64_STR64I(p->jited ? r0 : A64_R(0), A64_SP, retval_off),
> >> +		     ctx);
> > 
> > This should be only A64_R(0), not r0. r0 happens to equal A64_R(0) when
> > jitted due to the way build_epilogue() builds the function at the moment,
> > but we shouldn't rely on that.
> > 
> 
> looks like I misunderstood something, will change it to:
> 
> /* store return value, which is held in x0 for interpreter and in
>  * bpf register r0 for JIT,

It's simpler than that: in both cases the return value is in x0 because
the function follows the procedure call standard. You could drop the
comment to avoid confusion and only do the change to A64_R(0)

Thanks,
Jean

>
>
>  but r0 happens to equal x0 due to the
>  * way build_epilogue() builds the JIT image.
>  */
> if (save_ret)
>         emit(A64_STR64I(A64_R(0), A64_SP, retval_off), ctx);
> 
> > Apart from that, for the series
> > 
> > Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > 
> > .
