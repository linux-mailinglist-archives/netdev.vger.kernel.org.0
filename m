Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843AF52CE76
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiESIjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiESIjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:39:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F34577F12;
        Thu, 19 May 2022 01:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=g/oPe5bXk7tsbULLyYHhkrNj6UcyM44d11Xk1/aVMmY=; b=q6yzGmnt5k0dWGLzN+N/7kJIII
        I5rTrvru7kLRG3wr+UYoaPMbB1e2Qri5xfzHb5GHqQAVfJc0R0WXnphvur5nbLmog9nSj7S5VODIC
        sO5QfAA8o9UkWgXl/5J/j2kNOzfqSIgmy7QCmFnSb9oSdFELbAe3z+Sacpp58JSL8HkDNcuE3+ulW
        AZ/s/TuiUpNOlmr0HsAa2zOCXXQ+HBa6jpT1U1KxML/b5CvAsaaNFikomYd91zIfALWMsNiPMk2tD
        Vo4f9CAN3kDjtwf32oJIsYG/G8fwB8d1m7JQ93m85cJJGH0PE94C6Xn6GuF2bkhuINisDCuFcZG3l
        dB4HBWPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbgQ-005uXP-BN; Thu, 19 May 2022 08:38:58 +0000
Date:   Thu, 19 May 2022 01:38:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
Message-ID: <YoYCIhYhzLmhIGxe@infradead.org>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <YoX7iHddAd4FkQRQ@infradead.org>
 <YoX904CAFOAfWeJN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoX904CAFOAfWeJN@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:20:35AM +0200, Greg KH wrote:
> > are written using a hip new VM?
> 
> Ugh, don't mention UDI, that's a bad flashback...

But that is very much what we are doing here.

> I thought the goal here was to move a lot of the quirk handling and
> "fixup the broken HID decriptors in this device" out of kernel .c code
> and into BPF code instead, which this patchset would allow.
> 
> So that would just be exception handling.  I don't think you can write a
> real HID driver here at all, but I could be wrong as I have not read the
> new patchset (older versions of this series could not do that.)

And that "exception handling" is most of the driver.
