Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9E6F3011
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 12:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjEAKJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 06:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjEAKJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 06:09:36 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58C1E47
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 03:09:34 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f1958d3a53so22886755e9.0
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 03:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682935773; x=1685527773;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+Gvppe6QWhvqkJifz1exhwnVbb2K3JFtCWSqYW4DNIM=;
        b=mZ4bJ1HTemNSj78CRYUvbDt75cX6d5grrRjbZXNwHSDgcDzc27RXAAPSelkdw+bJ5B
         R9+wBRTp6c+fP/UWyHxt4Hh7IAbELoR0awoHY6hwa7KE9nhpTfYRt6DC2Tk9a4kf78z2
         wkSRv440S+i/W2Ht74Rp76cJOEsrtzbW4pPpA5daWXkR2N63vez+nJuamfAqrXikDX4K
         WQBqzUq8OrVAiL4r4bhtCO/rMB6sv7M43kT0Ld3ZnNqZw5KIz05AWVy/rBbtOlxKTL4E
         laNNZbnBJltH27xtcXb3BmZvbitqS+uxMlnE2Ne2ORSeEwebVQwAcPbNzo4+/ZBNXDMZ
         t6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682935773; x=1685527773;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Gvppe6QWhvqkJifz1exhwnVbb2K3JFtCWSqYW4DNIM=;
        b=j8c29ZeSJKrXP/T+eJvpKNF21VeKBHCU6SR0lN1MyyRVQIfDrgl/DRJYCGq7nTkpYA
         Binpex+Rpl1zTZNudAS4PkFySV2EOd3/uHo4Pmmkme87y4lcfTtYWfBKTU5BEOjSsX2i
         sed9zBXyydaMtXo1udcZ1Jk5Snj4xq6lpx5Co7MulHlfVbylrEn9wNhdscWl2GhweLhO
         E55X1f9uUCBq5OpXqq3sg3z4L4YviEMRTOT7ad/wkFKQzvM84zpcyrz4mO39M9UGiV9x
         LC0qpW3fbf/xI4BGtUoRP2AyLcaFNOHN85hD8gJX1ziVsvMY0dkXWKL0VmeRtIZL4Y0I
         WF4Q==
X-Gm-Message-State: AC+VfDyXbUPBOlCplBP+ARk+7XSTUvatXN3uCkWaHbMPVFqqsZyaNhr0
        ThNncZpb7C23MBd5vfsv5qA=
X-Google-Smtp-Source: ACHHUZ6MTsdVDzYuDWhH+p0+nn4c+oPrQG5i3khBhpTmuT+U3z0rRoZcO3J3A7JpvcGTQQgg8DqKBg==
X-Received: by 2002:a1c:f305:0:b0:3f1:93c2:4df7 with SMTP id q5-20020a1cf305000000b003f193c24df7mr9385094wmq.5.1682935772857;
        Mon, 01 May 2023 03:09:32 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c4f1200b003f07ef4e3e0sm45669601wmq.0.2023.05.01.03.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 03:09:32 -0700 (PDT)
Date:   Mon, 1 May 2023 13:09:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <20230501100930.eemwoxmwh7oenhvb@skbuf>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 10:52:12PM +0300, Arınç ÜNAL wrote:
> On 29.04.2023 21:56, Vladimir Oltean wrote:
> > On Sat, Apr 29, 2023 at 09:39:41PM +0300, Arınç ÜNAL wrote:
> > > Are you fine with the preferred port patch now that I mentioned port 6
> > > would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
> > > got 1G? Would you like to submit it or leave it to me to send the diff
> > > above and this?
> > 
> > No, please tell me: what real life difference would it make to a user
> > who doesn't care to analyze which CPU port is used?
> 
> They would get 2.5 Gbps download/upload bandwidth in total to the CPU,
> instead of 1 Gbps. 3 computers connected to 3 switch ports would each get
> 833 Mbps download/upload speed to/from the CPU instead of 333 Mbps.

In theory, theory and practice are the same. In practice, they aren't.
Are you able to obtain 833 Mbps concurrently over 3 user ports?
