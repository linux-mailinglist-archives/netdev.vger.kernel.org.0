Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A464379114
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhEJOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhEJOhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:37:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D84CC08E8A9;
        Mon, 10 May 2021 07:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=i6vAxLOytNOYwyM1NYfARO0i+7jkuFK7y9pYt7pXuwE=; b=djb3CWn/LU378IzapvABLkn8Gd
        Mp82QkScestEUeQW2L+zqtEN7XvYp31eFRebvjBEITr//+6YOo6+SYheq9BxF7YMTeqbS+RN1ORYU
        WcTwnub1JAhAEwo1EbdH4ZtDbzKRVhVt7KKBx8eH43WzT6ZsZkO7OQPiITlB671P2UStmst5kwHpO
        oLDGkct+Pf7s4vCchonkHPjgJ2dHAgGdY9eEvhnNfgt0nMzg4EJ/N8O7mpCEUjiq1yDlLopkoOUQy
        tCb7mahOMAZ84vugzBeIjfIYkNlViOtJdTlUAmJVQy5eePLrQct4R8yXLPW7Hy+DjovMg5jAZGdoa
        yuW/o03A==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lg6RA-006DIB-7H; Mon, 10 May 2021 13:59:19 +0000
Date:   Mon, 10 May 2021 14:59:08 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
Message-ID: <YJk8LMFViV7Z3Uu7@casper.infradead.org>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
 <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
 <20210510135518.305cc03d@coco.lan>
 <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 02:16:16PM +0100, Edward Cree wrote:
> On 10/05/2021 12:55, Mauro Carvalho Chehab wrote:
> > The main point on this series is to replace just the occurrences
> > where ASCII represents the symbol equally well
> 
> > 	- U+2014 ('—'): EM DASH
> Em dash is not the same thing as hyphen-minus, and the latter does not
>  serve 'equally well'.  People use em dashes because — even in
>  monospace fonts — they make text easier to read and comprehend, when
>  used correctly.
> I accept that some of the other distinctions — like en dashes — are
>  needlessly pedantic (though I don't doubt there is someone out there
>  who will gladly defend them with the same fervour with which I argue
>  for the em dash) and I wouldn't take the trouble to use them myself;
>  but I think there is a reasonable assumption that when someone goes
>  to the effort of using a Unicode punctuation mark that is semantic
>  (rather than merely typographical), they probably had a reason for
>  doing so.

I think you're overestimating the amount of care and typographical
knowledge that your average kernel developer has.  Most of these
UTF-8 characters come from latex conversions and really aren't
necessary (and are being used incorrectly).

You seem quite knowedgeable about the various differences.  Perhaps
you'd be willing to write a document for Documentation/doc-guide/
that provides guidance for when to use which kinds of horizontal
line?  https://www.punctuationmatters.com/hyphen-dash-n-dash-and-m-dash/
talks about it in the context of publications, but I think we need
something more suited to our needs for kernel documentation.
