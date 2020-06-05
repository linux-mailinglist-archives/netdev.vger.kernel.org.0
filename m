Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAF41EF339
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 10:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgFEIgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 04:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgFEIgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 04:36:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E13C08C5C2;
        Fri,  5 Jun 2020 01:36:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c3so8811685wru.12;
        Fri, 05 Jun 2020 01:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dq3oPyfqozgQNVIyIv74mybfG/tMTEM6HNLPoiq4pKw=;
        b=A4LMRLaae+oW4ofvbcr0vG+xLYd3wW/c/tZNs4zYNUsY2KdfkVkjco81/u5+zkqaYA
         5ZFsk0kX/XNnx3J/rZR+Q6+T1QJbYbHk9l4wc9sV7lpSh8IKD81cXLxrt16H7KZES1AW
         p1tWvEsGcmydNz6zRfdQJ9Lh4cCTh4gqVI4nMXlutJw6DoR01pWTFqCliysDRxZFyXHQ
         oNa5pis/C+LHiI4IHs8MFEIy4xSziE8BtWvW+lcckJvqjqZ6Phb3egKj/lCIw2r0OXTf
         J3/UbsfBK8Y3apbwhwGvmpSYTokD92yJ7hn3ElrnaNiJsnOq5cPqEvjNp63hl5619sKp
         j+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dq3oPyfqozgQNVIyIv74mybfG/tMTEM6HNLPoiq4pKw=;
        b=cE9EQnG/esfcbgrs5IxhCqpt0ydWV4h9oGrF9wLYBCHDVAkkd2nJ9oBrDatSOQwj3P
         UUWLmBuuBi7S0qJohgtZXHcWl6Ub/IdSYS3QknLrvpvcIW/Vp2Bmvjb693aV8pn+ChH0
         SM7vNY1abNCWp0ZYyJNwxntNJpIvK4AiaiU+BAqHcduZ7ZBlxZfhfh7vjZNZESWalDTL
         bv6Swn4aLrOMmmah7hf+SSrns8ASZRer/qsjsC7IMZCnT3GRQ7qHLFiWD5VznI/PI0xK
         32iiZSLB3IYb0xyRP2iO729UGvyTElmKhN6yAKP8Ums6l1Hef3BQBzSr3d9o4tXg2SOa
         xUuA==
X-Gm-Message-State: AOAM533FrP7Otr2rApQlrp6gmDOxMAoyySz+EoIjOlOEZpnVKv1vD/o2
        V/IWIMQpEAhldGyU+4IqLNL01baIOFQ=
X-Google-Smtp-Source: ABdhPJzYVycY3bZlLV6BrfEAJMimdCMCrmHbb+PtL0pnGXLNxfuetQ/tdoRiqKM0eEmwT7Y9paVK0Q==
X-Received: by 2002:adf:feca:: with SMTP id q10mr7852058wrs.380.1591346178861;
        Fri, 05 Jun 2020 01:36:18 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id c81sm10935509wmd.42.2020.06.05.01.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 01:36:18 -0700 (PDT)
Date:   Fri, 5 Jun 2020 09:36:16 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 11/13] vhost/scsi: switch to buf APIs
Message-ID: <20200605083616.GB59410@stefanha-x1.localdomain>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-12-mst@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-12-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 02, 2020 at 09:06:20AM -0400, Michael S. Tsirkin wrote:
> Switch to buf APIs. Doing this exposes a spec violation in vhost scsi:
> all used bufs are marked with length 0.
> Fix that is left for another day.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/scsi.c | 73 ++++++++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index c39952243fd3..c426c4e899c7 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -71,8 +71,8 @@ struct vhost_scsi_inflight {
>  };
> =20
>  struct vhost_scsi_cmd {
> -	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
> -	int tvc_vq_desc;
> +	/* Descriptor from vhost_get_avail_buf() for virt_queue segment */
> +	struct vhost_buf tvc_vq_desc;
>  	/* virtio-scsi initiator task attribute */
>  	int tvc_task_attr;
>  	/* virtio-scsi response incoming iovecs */
> @@ -213,7 +213,7 @@ struct vhost_scsi {
>   * Context for processing request and control queue operations.
>   */
>  struct vhost_scsi_ctx {
> -	int head;
> +	struct vhost_buf buf;
>  	unsigned int out, in;
>  	size_t req_size, rsp_size;
>  	size_t out_size, in_size;
> @@ -443,6 +443,20 @@ static int vhost_scsi_check_stop_free(struct se_cmd =
*se_cmd)
>  	return target_put_sess_cmd(se_cmd);
>  }
> =20
> +/* Signal to guest that request finished with no input buffer. */
> +/* TODO calling this when writing into buffer and most likely a bug */
> +static void vhost_scsi_signal_noinput(struct vhost_dev *vdev,
> +				      struct vhost_virtqueue *vq,
> +				      struct vhost_buf *bufp)
> +{
> +	struct vhost_buf buf =3D *bufp;
> +
> +	buf.in_len =3D 0;
> +	vhost_put_used_buf(vq, &buf);

Yes, this behavior differs from the QEMU virtio-scsi device
implementation. I think it's just a quirk that is probably my fault (I
guess I thought the length information is already encoded in the payload
SCSI headers so we have no use for the used descriptor length field).

Whether it's worth changing now or is an interesting question. In theory
it would make vhost-scsi more spec compliant and guest drivers might be
happier (especially drivers for niche OSes that were only tested against
QEMU's virtio-scsi). On the other hand, it's a guest-visible change that
could break similar niche drivers that assume length is always 0.

I'd leave it as-is unless people hit issues that justify the risk of
changing it.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7aBAAACgkQnKSrs4Gr
c8hc2AgAhA2GdtNYe8p56IbAFfd8fkuwV0WVMyeBsCNkDsrJLQqfOtQ9EGUI3lir
8Xfy6Gr4Swoy+7HIeicp4dmOCrY6J+gJx3ORqS1UncMUJghROp1Iucm/MK3VZq81
bY9Xx07KuKFJHv6127fdnjw36uQdIJxRWMfYW1EeGLeLLWxzyYv6E1ajDo5USsrG
/nlX5NHWdz1CZbQc8HZnuZ9dwTsMuLJYYyhQFUtaHm3UYQ+39XHFtk12dJiHhDvD
2QdziP4TCejE+N4ICXV9M9uLRPAMFHbhAdMTbCGjwYpk01FxGIQ/hD87TtBMiyNB
gINncRUX153Pu1g/rx/FGzPJ+rBTRQ==
=9PYW
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
