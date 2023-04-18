Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3853D6E5598
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjDRAIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDRAIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:08:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F09A49DD;
        Mon, 17 Apr 2023 17:08:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a677dffb37so11659735ad.2;
        Mon, 17 Apr 2023 17:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681776518; x=1684368518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYmxN4UjuYj06SpL1wUV2ZlF7dJmbG+ouluZz1JaIPk=;
        b=W6+Rs64v91YHB9S0YRvmXeDlPruSoE4mMoN+KXTP79AGcnJIY5/lm6DIz/0ynnE8uw
         HwLLiLsznh8rEOkCDlXcLQyWJOD55ZslovGGmaaryfjiZvLg3kFoMrr3oV7RWFIQC0Jv
         9wIjsxTfWPNESjcZScdcaUThqGkH3Z+ePap7JzGOpxVXufQn5bq6gjrhetjh+VWcMDPU
         tNMScdk4DKmMx1+xzXpanIpCkQr7KVQE8scB2cOc0OiIdg7RSnY2NBmpct8NrGl+BMJO
         UhlvZ3SnlLogL6q85Aoq/NGRNxjh63jje3NHNdZL7EvBu3bTWx13ySYCrzZT2HQ+BPPt
         6gPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681776518; x=1684368518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYmxN4UjuYj06SpL1wUV2ZlF7dJmbG+ouluZz1JaIPk=;
        b=AUNA0NZ1W0Z7YNX6TKBRlq+5uqqnNVjHXV0wbG9+AwT3TvQUyKCDl/XdW3loMlEbde
         65EnWVG/2eZ3WNIA3QS6mDhDZ+9iSCYLcLm0ubycQ6qVXOjU2X84snLzzpszpsR6fZy2
         +bPN0HhGjooA6tvUS+0E39OkS6BlLKroKs/GX3ZdXYdNQAOUY33IDJIoKidwcbXm3zNy
         R0Sam3IdUMlqTbTe5dpq4/FYe4M8SXbJ0jN2cPkviYxnL9v0RNTuLWh9xaIBNIi6228b
         MBI0np1LgruJENDBQs7TZUY1j9wgT8hMBA1K0VBZpDXRZ9dHDG/5YMDCTzbtkaQsEZ6Q
         6RdA==
X-Gm-Message-State: AAQBX9fJox//gtkPXITnTSJkLF/OmWOnepoGkTusNaziIfvl6mpl4rb4
        KlEqIyL7PWqvEH5NGXDPmIA=
X-Google-Smtp-Source: AKy350ZeCVb4KAbWOiKbk2S7teFEqQr2BBsW8R6ZfmRC80gnH89qNymkRqEtzaUgJ6bQXY90n+ubyA==
X-Received: by 2002:a17:903:1210:b0:1a6:4a64:4d27 with SMTP id l16-20020a170903121000b001a64a644d27mr268087plh.40.1681776517661;
        Mon, 17 Apr 2023 17:08:37 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:9cf7])
        by smtp.gmail.com with ESMTPSA id i2-20020a1709026ac200b001a64a2b790fsm8225505plt.164.2023.04.17.17.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 17:08:37 -0700 (PDT)
Date:   Mon, 17 Apr 2023 17:08:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com, zhouchengming@bytedance.com
Subject: Re: [PATCH 1/2] bpf: support access variable length array of integer
 type
Message-ID: <20230418000833.keqhb7kdpibgaodt@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <20230417080749.39074-1-zhoufeng.zf@bytedance.com>
 <20230417080749.39074-2-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417080749.39074-2-zhoufeng.zf@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 04:07:48PM +0800, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> After this commit:
> bpf: Support variable length array in tracing programs (9c5f8a1008a1)
> Trace programs can access variable length array, but for structure
> type. This patch adds support for integer type.
> 
> Example:
> Hook load_balance
> struct sched_domain {
> 	...
> 	unsigned long span[];
> }
> 
> The access: sd->span[0].

The use case makes sense.
Please add it as a selftest. Either combine it with patch 2 or another patch 3.
and then resubmit.
Make sure to use [PATCH bpf-next] subject, so BPF CI knows how to test it.
