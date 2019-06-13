Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06A43A98
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbfFMPWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:22:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45446 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731983AbfFMMlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:41:42 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so12583246qkj.12;
        Thu, 13 Jun 2019 05:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7pkx3WNGJ2fGQ9aapC2cYYTAgF2lpZWmmO7WTveiEGM=;
        b=gYSGicSt78FIgsXMXfEoyTiCZo31sujVNsK6hkwEPKdUv5pP0YPLyB4O6Couyp1x/h
         x2LHOBd7E8HLhhoct+Tiww0HEnj1Q5IUBmn8DbmSB+KZU4wwDza6uKry+RNLINxjKDsC
         eP4+j70G33mPVYchVigKSRf+qTxxoR+WgiygQSXXvv/J8BjL9Et3vdUgo4aiIj3ah47I
         +TzHLkHXjP2ZVxvTSTUlHML6givpE13YVfQAFZPHwaHiUfmkqWxaNhV9RPBrYIc8I/S8
         obP0P6AaBfWC8YhyVKZjXKOnbpMa1I5GpKbzrxztGP5Es6eEQRQQybGjmV+6jE15sjQw
         bQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7pkx3WNGJ2fGQ9aapC2cYYTAgF2lpZWmmO7WTveiEGM=;
        b=LmUY56HlnuoIKWuyeuE2pyJTCEn6qQTXIITdWCWZw1tn01IjHY6DVfed2utsI4ZDZd
         6nLwLWkh1GHd9V8r0QZvtYLV/w2SNNpAUXyTzCiTIqBhThnYxp69h/Rcdhz18q4Py8R4
         6O6vU30o0C0Uiw4Pki3V0j7yEGUKF6evu9OU1lzp+PX2hsSOw94W/4QUTHyGXYzYjeH+
         Rgbz6ziGIKSYtt7fLt8jqntCk5u4r6BsvtMrQF5S347doqvotLPqRPijVI9Po/MMfcpJ
         qYicBAPNSNdptxAEdJK9p+tO/wa+3FU9RvifM2JG3BjAL5IWCgLpCrmxOGzCzQXfWPMG
         U/LA==
X-Gm-Message-State: APjAAAXQQdfkcEPNJfkXqfjwor7R3hnrjR+YaW4RfjrYqPNpupJBmqhK
        PlUjNp/2sTqt3zb9tglu6wW8r8EHujez9jLb5Tw=
X-Google-Smtp-Source: APXvYqyNtL526WFONEOjo1b23PxNloYxAAbPsKaFBgU5ZylWfilwuUeRaTUaK6QZSgSa6Grqt2pkeO1FUAw9KMItAp0=
X-Received: by 2002:a37:6282:: with SMTP id w124mr27918552qkb.33.1560429701372;
 Thu, 13 Jun 2019 05:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
In-Reply-To: <20190612132352.7ee27bf3@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 14:41:30 +0200
Message-ID: <CAJ+HfNjp6DJe5xdWxe6pPysXu8D24P4Pp7WcEt4N4EhE1sZNGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 at 22:24, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 12 Jun 2019 15:56:48 +0000, Maxim Mikityanskiy wrote:
> > Currently, libbpf uses the number of combined channels as the maximum
> > queue number. However, the kernel has a different limitation:
> >
> > - xdp_reg_umem_at_qid() allows up to max(RX queues, TX queues).
> >
> > - ethtool_set_channels() checks for UMEMs in queues up to
> >   combined_count + max(rx_count, tx_count).
> >
> > libbpf shouldn't limit applications to a lower max queue number. Account
> > for non-combined RX and TX channels when calculating the max queue
> > number. Use the same formula that is used in ethtool.
> >
> > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> > Acked-by: Saeed Mahameed <saeedm@mellanox.com>
>
> I don't think this is correct.  max_tx tells you how many TX channels
> there can be, you can't add that to combined.  Correct calculations is:
>
> max_num_chans = max(max_combined, max(max_rx, max_tx))
>

...but the inner max should be min, right?

Assuming we'd like to receive and send.
