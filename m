Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D38EDE049
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 21:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfJTTx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 15:53:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45049 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725933AbfJTTx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 15:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571601206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RoTulD9MOFa0djSkZWXs2Pa14XJ8IT9sFb5LBl9c74=;
        b=RL+t9jVtHNz+ZMUH24GAFs13Nk2f9S8Q3+cI0HGMEp+1q52HwkNDsQ0QuQGsegfCKVYjrz
        XJ8ZUfhU2k52WG11e3fMAZGg6QR6v+6Tbtqa289gY9V8q/TCx++9ZqqGAOzfdFRfFn4v2m
        ayyeHHrl/3ianStSYSqrf4957TFnwRU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-xIfLpFHMNPOOhLK_u13f2w-1; Sun, 20 Oct 2019 15:53:23 -0400
Received: by mail-lf1-f70.google.com with SMTP id c27so2187258lfj.19
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 12:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/RoTulD9MOFa0djSkZWXs2Pa14XJ8IT9sFb5LBl9c74=;
        b=T4yQWPbVGx5TJkW6XKpDeTNqegg4vHu/J3Uo98ljakJp9DzrUdkq60jdBCcEnBTIlM
         v/vtiqXoj9JbqMznh+BXMO1VoyjJnq3MEQshvtW8VsK1rCFOh7P85bDhOTjr7qlxkK1s
         gDBSaeLqcW4fa+/TX8jlbt8ffDtix+vY6N18Tt+fMgfFrJDCxz55JXmRkxZy+zP4f9IU
         FYvCabGS5/vFkANSNtphwdIQD0o8AG2SgpDrMijUs9XXHfbF8IN1+hrZ9AIoQndVNP8d
         wKZB9LIVCoPQ5gnCZ/IGJpiZJSigA4Xce2a2bOMzULI7ctW5vYVFAWVBlB97ZUFLd96H
         8pig==
X-Gm-Message-State: APjAAAVYxUVUETmz9cD+gyvqEqknNaGy9gfbhGYk4BOV7Ab2TYOn66bf
        baXew9/ikZIR1RDpETxG1lbAK7MDKlK7l3kF9jBDNCOPx23C9cyH325s9oWonoVLJNMGvg39ek0
        L2Qi1WoIPWPzt5I5Y
X-Received: by 2002:a2e:b010:: with SMTP id y16mr12754063ljk.147.1571601201965;
        Sun, 20 Oct 2019 12:53:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4ufgaRtQlS1mi37PhH0ZYcQojIe7K50PX7Ic+eL6f7Tms3i7R8zmzNBStFWmMLp8JKE/W+w==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr12754058ljk.147.1571601201789;
        Sun, 20 Oct 2019 12:53:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f28sm5937387lfp.28.2019.10.20.12.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 12:53:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 24BE7180321; Sun, 20 Oct 2019 21:53:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, sridhar.samudrala@intel.com
Subject: Re: [PATCH bpf-next] libbpf: remove explicit XSKMAP lookup from AF_XDP XDP program
In-Reply-To: <20191020170711.22082-1-bjorn.topel@gmail.com>
References: <20191020170711.22082-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 20 Oct 2019 21:53:19 +0200
Message-ID: <87pnirb3dc.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: xIfLpFHMNPOOhLK_u13f2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
> eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
> which means that the explicit lookup in the XDP program for AF_XDP is
> not needed.
>
> This commit removes the map lookup, which simplifies the BPF code and
> improves the performance for the "rx_drop" [1] scenario with ~4%.

Nice, 4% is pretty good!

I wonder if the program needs to be backwards-compatible (with pre-5.3
kernels), though?

You can do that by something like this:

ret =3D bpf_redirect_map(&xsks_map, index, XDP_PASS);
if (ret > 0)
  return ret;

if (bpf_map_lookup_elem(&xsks_map, &index))
   return bpf_redirect_map(&xsks_map, index, 0);
return XDP_PASS;


This works because bpf_redirect_map() prior to 43e74c0267a3 will return
XDP_ABORTED on a non-0 flags value.

-Toke

