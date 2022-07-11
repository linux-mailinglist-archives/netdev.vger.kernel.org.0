Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0C057061B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiGKOsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiGKOso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:48:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFA95F77
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:48:40 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r14so7359081wrg.1
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OeIwrghjWv1itdsEcBmUCDSZH1m4e3A3+aJ94H0DMKA=;
        b=mi5bzmfy76j/A0JqIGs4L9rTEq0UWTfjTNwH3NpU3XTt27ad7yjuV7drDTaywqs6A+
         4+PQPa4vsJKRy6zcuawPUL65Zf2/19jaUHFTHnDHJHoeYqW25gy1LmILfUYjWKW86eWD
         FdIkLUsvTwlzo4+ghyC3YeigJia/vQ2OWjAv0x/qmIllC6gdLkN6JHZa70zbttJAJAfv
         e9d7JAzmuIQlfoZFZpczZcL4OKiCrJGT8QxC7Ew3F+fgtuD6T9nlF+Qb1/zAgoj4rnQx
         w7l9P5A7lTiEzPIA+YBAS9jO5qh1tsVoyq5mcISyDKbf1uPs08WSzfO8ZO+gwos0AU8D
         l5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OeIwrghjWv1itdsEcBmUCDSZH1m4e3A3+aJ94H0DMKA=;
        b=NaxEYAvzYQOXSznSB4paXqBRKsd5pl/eGEpr9pyxM0U+uCAr2ndrcpLhFn4Yft+lTT
         I9sSEhkaDEQAf27MDpuJ+4P3SZiS/GVIjvXxlLwCW4aV4Tfs9BSUGtshnkPYbyTiOU21
         PPdmKdXfFduWnZbpv8M4hIb3MwoXOVI183TR6kTOYuU4jOG/XY2xIDoDf2TuevdR/Xr+
         /T8dXl4MmL46CG79dEsK0grpaOKIobV9LHsbpjhRYCCL5dfU2dqJK9hUgyLMk7P7ktrg
         4JrOVUSDachdNVvlotFR5ju2yuMgG22zwj56voODKPV8j63fMzY1JAmzuKCLZKDWcS41
         l6nw==
X-Gm-Message-State: AJIora/sQwc9/0VCr9faxpzemFxgki6mRdcSQqR/2iV24PGq9iZPq7Sj
        92rL7dPkXgsk0WJVUWF+ZcGoSk1Ik9ljrFe5
X-Google-Smtp-Source: AGRyM1vscC01dfCS/5xXseWFralreHKQW/CSj8vShH3qf6EqRgbWjqqNp17PAFhHjKV/myPWE6uc+g==
X-Received: by 2002:a5d:6e5c:0:b0:21d:7ba1:3601 with SMTP id j28-20020a5d6e5c000000b0021d7ba13601mr17597477wrz.554.1657550918856;
        Mon, 11 Jul 2022 07:48:38 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id b17-20020adff911000000b0021d819c8f6dsm5922653wrr.39.2022.07.11.07.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 07:48:38 -0700 (PDT)
Date:   Mon, 11 Jul 2022 15:48:13 +0100
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
Message-ID: <Ysw4LaMuNZQsoQXp@myrica>
References: <20220708093032.1832755-1-xukuohai@huawei.com>
 <20220708093032.1832755-5-xukuohai@huawei.com>
 <YswQQG7CUoTXCbDa@myrica>
 <4852eba8-9fd0-6894-934c-ab89c0c7cea9@huawei.com>
 <Ysw1nSxQUghvY/eY@myrica>
 <893b2d5f-16e9-0b1d-4ae6-8199e0f4ccf8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <893b2d5f-16e9-0b1d-4ae6-8199e0f4ccf8@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:40:42PM +0800, Xu Kuohai wrote:
> On 7/11/2022 10:37 PM, Jean-Philippe Brucker wrote:
> > On Mon, Jul 11, 2022 at 10:16:00PM +0800, Xu Kuohai wrote:
> >>>> +	if (save_ret)
> >>>> +		emit(A64_STR64I(p->jited ? r0 : A64_R(0), A64_SP, retval_off),
> >>>> +		     ctx);
> >>>
> >>> This should be only A64_R(0), not r0. r0 happens to equal A64_R(0) when
> >>> jitted due to the way build_epilogue() builds the function at the moment,
> >>> but we shouldn't rely on that.
> >>>
> >>
> >> looks like I misunderstood something, will change it to:
> >>
> >> /* store return value, which is held in x0 for interpreter and in
> >>  * bpf register r0 for JIT,
> > 
> > It's simpler than that: in both cases the return value is in x0 because
> > the function follows the procedure call standard. You could drop the
> > comment to avoid confusion and only do the change to A64_R(0)
> > 
> 
> OK, will send v9 since v8 was just sent

Right sorry about this, I could have been clearer

Thanks,
Jean
