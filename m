Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE285A59F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfF1UII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:08:08 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41259 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfF1UII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:08:08 -0400
Received: by mail-qk1-f194.google.com with SMTP id c11so5945553qkk.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lLlyQ5kaVdrnVnTcB00toGJYu3J4KQ63Sf7wJuxSF38=;
        b=lAImNVy2wuKqDzk0eT7Y0yCpet+4NuMsmicwG6h5GYWdn/DM1hGMDyXRHePbMaSCFp
         ZZMOQAYxt+Lw9TuVKgKb58swI2j23U9jmuYEwIGvxAfMEEV1z+OKV3+k9xlB59KjFtBP
         AoPNT3o2l3v1rFC0i8j+vdzqPtBYoTj4/pzSnQcxo6k7h9EOuwkLvOxPBlqLY2uxZvbp
         XzO/F3137NVDib6689Vp72u9Xej86GPp4cgsbKKrXZjN8c2UZoQg+kpDcRpDhL1A4fEN
         zMpyf07IKJyTOhWPleaGZwIC+6gEwVtdS/81cyoNaiE7pdbFiYfnNjoo9CiGpGCGR5Yg
         1DUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lLlyQ5kaVdrnVnTcB00toGJYu3J4KQ63Sf7wJuxSF38=;
        b=PLNmQV2dB25QkJzGwthETosanOpkKE+dHEecKBBMr0yZXq/vXIRmsYtUSNI3PrFC+l
         P4furQmDzQglri8/JyoMFjxIMMfbNDvCe+xQgUQDWNnWHLSdPVNGGs4qAjs69jEZUBOS
         /ObrcWl+YQ1zvJxJDgFZEp99bZkI8riipfiZ/Ik1eXue8S+GPh7OBmx6k7FfIoqZlorn
         axo6T74bd74jHGmM0IyH8wnoPfI926LqwngxJRaSdVaoawBZcoH+bo1pGJ1UtcAv6qZG
         uRpU5jLmfyG/kxpx2D0/NWCvDiRJNC72LpMtBobi19bwSQRCbiAP2tZfHxJzg1ufzQOV
         pODA==
X-Gm-Message-State: APjAAAXxyBy7KgeTa7/z6eb2Y1MhhXBudWYJWCC+O5NhS226TZi/ITlE
        /jGEOktdxDYe3niskM6UN0NeDw==
X-Google-Smtp-Source: APXvYqzPVSl9Mlk2IgUzorxAnmeH0zfdmUjZNznUbKqTU35x+liTQL1dOpc7XAVjQlCoP/VzppdApg==
X-Received: by 2002:a37:bc84:: with SMTP id m126mr4150878qkf.303.1561752487472;
        Fri, 28 Jun 2019 13:08:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a19sm1734793qka.103.2019.06.28.13.08.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 13:08:07 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:08:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     "Laatz, Kevin" <kevin.laatz@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Message-ID: <20190628130802.24a6f22b@cakuba.netronome.com>
In-Reply-To: <f6fb0870-b5b4-9aba-bfb5-b4248a95da79@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
        <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
        <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
        <20190627142534.4f4b8995@cakuba.netronome.com>
        <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
        <f6fb0870-b5b4-9aba-bfb5-b4248a95da79@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 18:51:37 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> In your example Jakub, how would this look in XDP? Wouldn't the
> timestamp be part of the metadata (xdp_md.data_meta)? Isn't
> data-data_meta (if valid) <=3D XDP_PACKET_HEADROOM? That was my assumptio=
n.

The driver parses the metadata and copies it outside of the prepend
before XDP runs.  Then XDP runs unaware of the prepend contents. =20
That's the current situation.

XDP_PACKET_HEADROOM is before the entire frame.  Like this:

    buffer start
  /               DMA addr given to the device
 /              /
v              v
| XDP_HEADROOM | meta data | packet data |

Length of meta data comes in the standard fixed size descriptor.

The metadata prepend is in TV form ("TLV with no length field", length's
implied by type).

> There were some discussion on having meta data length in the struct
> xdp_desc, before AF_XDP was merged, but the conclusion was that this was
> *not* needed, because AF_XDP and the XDP program had an implicit
> contract. If you're running AF_XDP, you also have an XDP program running
> and you can determine the meta data length (and also getting back the
> original buffer).
>=20
> So, today in AF_XDP if XDP metadata is added, the userland application
> can look it up before the xdp_desc.addr (just like regular XDP), and how
> the XDP/AF_XDP application determines length/layout of the metadata i
> out-of-band/not specified.
>=20
> This is a bit messy/handwavy TBH, so maybe adding the length to the
> descriptor *is* a good idea (extending the options part of the
> xdp_desc)? Less clean though. OTOH the layout of the meta data still
> need to be determined.

Right, the device prepend is not exposed as metadata to XDP.
