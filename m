Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D3EA3A1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfJ3SuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:50:23 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45128 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfJ3SuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:50:23 -0400
Received: by mail-lf1-f66.google.com with SMTP id v8so2377576lfa.12
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 11:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sScJ+ihKM+c7CWPxPR/dEicsUcm4CgHIxO1wNfvED2M=;
        b=VMv6vgW1MeALURRTAjJPlFR38Apt6PrvIaXyZENx4U5G6ZX7lIsU0PbLQVD9XPBXq0
         XH1GwTHM+m5nvLoWGLcTP2Cr/cmApO92K5W/XWJYU+7T67Y2np5Nyyd7p8ZDohC1LvXp
         e0tzuE+Un7pQYZT5aoT/ze8DtzMVThUaH+yGvo4iXB5NOr/IBF5dWYWt70tmj25u3c4O
         mvjJzeVxktjZp6WsXgqMj/ZB3p7SHYPuCyCb+4CTXeooONUVrNHwI6RCjwjTERWwWO85
         kYyekHU6DccgUTV1L9x6OQpVaeBAQqs47lQH37Kg1woDrxMEvVKaJuENV3gvTjP+A+FD
         RkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sScJ+ihKM+c7CWPxPR/dEicsUcm4CgHIxO1wNfvED2M=;
        b=OV2mlGb6K3FuJYEJVsCaBbHcDUeDkoGZ7eOUCql8pBLrK+F/ww2MbD5uPfCCY/XzSB
         mqpABjxAGZBv17ndyacBW5OS6BGhZOKWqDReVhliBK0+aoMzw9HXYdq9RWj75R44vl9T
         OdpdGvFxKFF+ArN76cvWepg4rC6wX9OjmmRjdOU6rXY58GxlBShzr/ty65Xjs6ilKoKc
         +z7eDofIyFciozaaF+sNIcEwTQy/BU8l+mfu2HOSx7DNKyDDKITyAYFCY8Lhyd3adfXv
         WA68OptIauTz0rrWpQIHEZFaQFhTNy1YW6dpZeqQ8AEZRvCF8ag7UKrH3DoEQ4Aw7IO/
         Cx2w==
X-Gm-Message-State: APjAAAWiTKiraZ/ZkQgvt7WWhqU6Uoa0JWxF9sdRc2BU/LA6hNzJVjO5
        kHDWUCNCKXImzncDlsSiIDFoig==
X-Google-Smtp-Source: APXvYqyFdeSENAPGoCAwF5+eIiNAY8uKesk+W3TAQzWEyLEWOBUtBJfoJYuMIVK5Ogpu7+cMEq3LvA==
X-Received: by 2002:a19:e018:: with SMTP id x24mr377292lfg.191.1572461421343;
        Wed, 30 Oct 2019 11:50:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o5sm409230lfn.78.2019.10.30.11.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 11:50:20 -0700 (PDT)
Date:   Wed, 30 Oct 2019 11:50:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 5/9] ice: Add support for AF_XDP
Message-ID: <20191030115009.6168b50f@cakuba.netronome.com>
In-Reply-To: <20191030032910.24261-6-jeffrey.t.kirsher@intel.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
        <20191030032910.24261-6-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 20:29:06 -0700, Jeff Kirsher wrote:
> +/**
> + * ice_run_xdp_zc - Executes an XDP program in zero-copy path
> + * @rx_ring: Rx ring
> + * @xdp: xdp_buff used as input to the XDP program
> + *
> + * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
> + */
> +static int
> +ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
> +{
> +	int err, result =3D ICE_XDP_PASS;
> +	struct bpf_prog *xdp_prog;
> +	struct ice_ring *xdp_ring;
> +	u32 act;
> +
> +	rcu_read_lock();
> +	xdp_prog =3D READ_ONCE(rx_ring->xdp_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		return ICE_XDP_PASS;
> +	}
> +
> +	act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> +	xdp->handle +=3D xdp->data - xdp->data_hard_start;
> +	switch (act) {
> +	case XDP_PASS:
> +		break;
> +	case XDP_TX:
> +		xdp_ring =3D rx_ring->vsi->xdp_rings[rx_ring->q_index];
> +		result =3D ice_xmit_xdp_buff(xdp, xdp_ring);
> +		break;

=46rom the quick look at the code it wasn't clear to me how you deal with
XDP_TX on ZC frames. Could you describe the flow of such frames a
little bit?=20

> +	case XDP_REDIRECT:
> +		err =3D xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> +		result =3D !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fallthrough -- not supported action */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> +		/* fallthrough -- handle aborts by dropping frame */
> +	case XDP_DROP:
> +		result =3D ICE_XDP_CONSUMED;
> +		break;
> +	}
> +
> +	rcu_read_unlock();
> +	return result;
> +}

