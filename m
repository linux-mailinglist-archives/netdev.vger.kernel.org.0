Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE15E6D74
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiIVU7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIVU7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:59:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF1DD69C0;
        Thu, 22 Sep 2022 13:59:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso3409013pjd.4;
        Thu, 22 Sep 2022 13:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=U3NGbjctdNtYZUAw53yWij8HwInl1GKHMSlSeRHwL2A=;
        b=O94ciy7HakFm25cgL9FxzuFEvodLFGdVNX4xWMGxwhnQ9kRVsEdnU9538O5Z6Y/zRM
         ICn2RYFoam+WVao99bv2zTAsu6If+eHCcUwdNR9e6QyjVNjif/fi0Y2Ww202HB7rPUzT
         0OPBqhJK/p0JiJhAso96iAiGciuZLso6k1kwtZ1mHSHGqteBCxja3tlHDKWICjNWm62o
         k/2hRRnLCPl44cW/dPQqlJQKSWf4sgDTael/1STTxuhKVM2wmA72AziOr1vaq2umKCmt
         Sp9PyEXx5QrTBb35iqpqrkVcvFibgp8Tj4onsnkM2heTUouvjOyw+28ib2oiiHgIiEXV
         SXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=U3NGbjctdNtYZUAw53yWij8HwInl1GKHMSlSeRHwL2A=;
        b=4lSK9l84I9syvKF6YEtOkFfnr8cLnvcWQAZ850OmBZ2cUEcv2trGSrZMb3i0vQdkEn
         WEzAJjOsDtiZrT/XSgBdu1uDQFlbAc0KLJMgHLia1kEFeM50Xt7bfe5nnyLa5JGPqPyT
         YmPydO0x0dk0NsfgbXFRjbiIgdw6fyHjVyi8tXAz/N3u1yRkwCy3s0XoeUwdq/T6ZtJ1
         oxmpC77kZOXlP2oxi9QQujZmqL4zl3FycoImGvDn2jfQRZG8eIOBrnMlMZA1lUxK3Uq9
         VfvpTLrhsZwnamNqVkkS1n8uiYSKtMg18UMPxuXQNnqLc1aSS1PQA3dtFNW3W7gYvtM5
         ZYHw==
X-Gm-Message-State: ACrzQf0GLN0DxpxTmtYWPuHL/xDB0rohU98nlP5zAx7FlcjByZNcaBYS
        Fw69lQix/hPAbyte6SI1UOPQ2KnKYx3BPWXYZ9k=
X-Google-Smtp-Source: AMsMyM6oJjIZZLJOip9RU/PURA1Apfde1gyOXQdWAhXUo+O1vvKxwVKmxa5bDasXL2u3+HXcXog35fGDjELw4SR2P7I=
X-Received: by 2002:a17:90b:3912:b0:203:c0a0:f582 with SMTP id
 ob18-20020a17090b391200b00203c0a0f582mr12014942pjb.141.1663880342080; Thu, 22
 Sep 2022 13:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <2254584.ElGaqSPkdT@opensuse> <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
 <2834855.e9J7NaK4W3@opensuse> <d4e33ca3-92e5-ba30-f103-09d028526ea2@intel.com>
In-Reply-To: <d4e33ca3-92e5-ba30-f103-09d028526ea2@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 22 Sep 2022 13:58:50 -0700
Message-ID: <CAKgT0Uf1o+i0qKf7J_xqC3SACRFhiYqyhBeQydgUafB5uFkAvg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 1:07 PM Anirudh Venkataramanan
<anirudh.venkataramanan@intel.com> wrote:
>
>
> Following Fabio's patches, I made similar changes for e1000/e1000e and
> submitted them to IWL [1].
>
> Yesterday, Ira Weiny pointed me to some feedback from Dave Hansen on the
> use of page_address() [2]. My understanding of this feedback is that
> it's safer to use kmap_local_page() instead of page_address(), because
> you don't always know how the underlying page was allocated.
>
> This approach (of using kmap_local_page() instead of page_address())
> makes sense to me. Any reason not to go this way?
>
> [1]
>
> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-1-anirudh.venkataramanan@intel.com/
>
> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-2-anirudh.venkataramanan@intel.com/
>
> [2]
> https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/
>
> Ani

For the two patches you referenced the driver is the one allocating
the pages. So in such a case the page_address should be acceptable.
Specifically we are falling into alloc_page(GFP_ATOMIC) which should
fall into the first case that Dave Hansen called out.

If it was the Tx path that would be another matter, however these are
Rx only pages so they are allocated by the driver directly and won't
be allocated from HIGHMEM.
