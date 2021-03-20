Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7CB342A3C
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 04:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCTDnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 23:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhCTDm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 23:42:58 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F22C061761;
        Fri, 19 Mar 2021 20:42:58 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so10454747otk.5;
        Fri, 19 Mar 2021 20:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mZG86UjrWc/s9wTcWCLvG2sfbbAYjJbFrMRaDNHgBD8=;
        b=Q2FSdctjoURSvcz8/0nKdt7HYyzPbx1hCBOEy8/85bxWSlZK4CiW+qrVHVA+3uhCO8
         m2KcAiGZ9HaFvgDm3AHP5q7B53/Qd4//pXIW/fHN90se7mz6vRs1bHqhEvheANUP8Ot9
         nRPHgRB4gbvA4v4MOr9O21zJjF8Mna2EQAIHZOeV5wdNTn7SxRHcfIvpJdzIBtsnGCf1
         zZqmR0fSzkwbC7TALDldSqoCjZw/LSD2Wp3+ZP1MZuPaHGsycp2tnhx7HdpDUiJbrbuG
         gkrJvWdXwPfud/HZvrTqBUW3vUybX94xdlNOP1jaEqrymgqpCeESH9h6HIcOdvn/dWC7
         pmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZG86UjrWc/s9wTcWCLvG2sfbbAYjJbFrMRaDNHgBD8=;
        b=TLhGCCVlHBckOuKOWidpG0wUoI5wf3QbGAFy8ZPIk3ASJckyRA9Mjvv2Q92hYw6f86
         3syg1nY9m0r2ctedY5ALyyja/FPkx19FOT7YPfFqyUYGQk1AUYF30ZNe2Y7RV7PLIQAQ
         VdCh6BkGRZYpAxUBBihjdhEQgVEEAFE/hs+yl75b7p1V84ncn6+l739HMCT4qGFiL36J
         QsIZcPZGHNCdTvNwM0vCEC+AdYGrvFjhem89MnY1QykWsbK6FSPcQdikr/F64Qy79CoM
         3IJF+Ya08vLqpIshjHW/1puuMecxJw1GBjMyIHddglsu3TLBb0fvcJHU2TUTi47XrGz6
         TWVA==
X-Gm-Message-State: AOAM533weKcI8WdlNLXDFyQO+J+3Ho69fI1cJcLwwqX+70EsPSMWfZa4
        +jffIRQ04hGjz450G4Ujo4I=
X-Google-Smtp-Source: ABdhPJwYk/ursx2tTBt6OmjJ85fcG/kkaIWEBcMSdiQJas80gaCmQ2RIvvrPLA9Ltl3ZttjS9YVUNQ==
X-Received: by 2002:a9d:7081:: with SMTP id l1mr3494351otj.358.1616211777607;
        Fri, 19 Mar 2021 20:42:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e449:7854:b17:d432])
        by smtp.googlemail.com with ESMTPSA id l17sm1763024otb.57.2021.03.19.20.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 20:42:57 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 10/14] bpf: add new frame_length field to the
 XDP ctx
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
References: <cover.1616179034.git.lorenzo@kernel.org>
 <a31b2599948c8d8679c6454b9191e70c1c732c32.1616179034.git.lorenzo@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a5ff68f0-00a1-2933-f863-7e861e78cd60@gmail.com>
Date:   Fri, 19 Mar 2021 21:42:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <a31b2599948c8d8679c6454b9191e70c1c732c32.1616179034.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 3:47 PM, Lorenzo Bianconi wrote:
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 19cd6642e087..e47d9e8da547 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -75,6 +75,10 @@ struct xdp_buff {
>  	struct xdp_txq_info *txq;
>  	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
>  	u32 mb:1; /* xdp non-linear buffer */
> +	u32 frame_length; /* Total frame length across all buffers. Only needs
> +			   * to be updated by helper functions, as it will be
> +			   * initialized at XDP program start.
> +			   */
>  };
>  
>  static __always_inline void

If you do another version of this set ...

I think you only need 17-bits for the frame length (size is always <=
128kB). It would be helpful for extensions to xdp if you annotated how
many bits are really needed here.
