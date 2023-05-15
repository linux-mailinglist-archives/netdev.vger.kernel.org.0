Return-Path: <netdev+bounces-2475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C04A70229B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42A28281058
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38DB01FAE;
	Mon, 15 May 2023 03:50:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251321C26
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:50:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB030114
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684122640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlgOKeMU8sZCgVQ7u4z2s1Xk51R+ieMNOrbfLjiM1m4=;
	b=TXVBLKckj1pBo60ALoB99fypq1uQbkCI+KfTU0LTUHWY4RKiAL+jhY9jZHQcgXBru/VY/f
	77Qh06IZDRCTckw+E3GSYT+Wxw2f206x07THZvVrHKMEpBpGh+M0Ol98lRji3VvivWFbG0
	KwKp1oM9NfsuzpgcndlM/tfqXUT+oIg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-Xa6nqlRPPSuY5QxLp69KfA-1; Sun, 14 May 2023 23:50:39 -0400
X-MC-Unique: Xa6nqlRPPSuY5QxLp69KfA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4ec817fb123so6494748e87.3
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684122637; x=1686714637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlgOKeMU8sZCgVQ7u4z2s1Xk51R+ieMNOrbfLjiM1m4=;
        b=fv5SzMmPmcOkOtJpTxb+SsORPuU6EG7G4rjSD+EM26FaK3SlXCt3oMvEIBWGDWJEYm
         Gcy0hqkESSWd/r9gfPb4OGFXfIwWhOTZLgIuLwGdZsRRWhMiFK3x1zs3IHVTYiggMj9J
         Vza2mOyfzybTVKJEOyE1oA4VV9ICurvZANiKMifgf0V8HkNR2EAWTTRFTMv1flBL/+j0
         awcRY2+VJOyQXP+t0kXA7B+3INAQrGrNDr+FKBSiBVgmN1LwyGvWnpjtoQO1uQs5ibvF
         7OR57b9Ii9hrPorS5LLaHGJ5Zdg/abQsa1EqZnVD9nQLCfNIBupfkdcBPjs0nHfh2VrD
         +xAA==
X-Gm-Message-State: AC+VfDxKBIcFNAjbVrQdlYZGfSuZIwzst5NZZI8oJsIIENbP9qjM0N8M
	V2+5TLu161aKBa4a942cgNovSez3HGPNlsmNDe/eFNQDUUtaQsl3aoMEyrkqsfJYllqkAnCUfYH
	m077m6M1GcjXCr1eDXEYf1yAkhKyo6uGTmTreeTIhWONe8w==
X-Received: by 2002:a05:6512:51a:b0:4ef:ef8e:56f1 with SMTP id o26-20020a056512051a00b004efef8e56f1mr5325361lfb.49.1684122637291;
        Sun, 14 May 2023 20:50:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5APt1iTurZaCkOlm9pGbfVh6AjM9hGo6XsKrJ8xp5simix+qL8YrNhnXWntZnIv+aCQ0rG4IRNx2pxpk34xHI=
X-Received: by 2002:a05:6512:51a:b0:4ef:ef8e:56f1 with SMTP id
 o26-20020a056512051a00b004efef8e56f1mr5325352lfb.49.1684122636914; Sun, 14
 May 2023 20:50:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230503181240.14009-1-shannon.nelson@amd.com> <20230503181240.14009-6-shannon.nelson@amd.com>
In-Reply-To: <20230503181240.14009-6-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 11:50:25 +0800
Message-ID: <CACGkMEvOB6+Db+KmftFihOTuU11zL0zLcrPbsq=LOgK18qm90g@mail.gmail.com>
Subject: Re: [PATCH v5 virtio 05/11] pds_vdpa: new adminq entries
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	brett.creeley@amd.com, netdev@vger.kernel.org, simon.horman@corigine.com, 
	drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 2:13=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> Add new adminq definitions in support for vDPA operations.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  include/linux/pds/pds_adminq.h | 266 +++++++++++++++++++++++++++++++++
>  1 file changed, 266 insertions(+)
>
> diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_admin=
q.h
> index 61b0a8634e1a..c66ead725434 100644
> --- a/include/linux/pds/pds_adminq.h
> +++ b/include/linux/pds/pds_adminq.h
> @@ -605,6 +605,257 @@ struct pds_core_q_init_comp {
>         u8     color;
>  };
>
> +/*
> + * enum pds_vdpa_cmd_opcode - vDPA Device commands
> + */
> +enum pds_vdpa_cmd_opcode {
> +       PDS_VDPA_CMD_INIT               =3D 48,
> +       PDS_VDPA_CMD_IDENT              =3D 49,
> +       PDS_VDPA_CMD_RESET              =3D 51,
> +       PDS_VDPA_CMD_VQ_RESET           =3D 52,
> +       PDS_VDPA_CMD_VQ_INIT            =3D 53,
> +       PDS_VDPA_CMD_STATUS_UPDATE      =3D 54,
> +       PDS_VDPA_CMD_SET_FEATURES       =3D 55,
> +       PDS_VDPA_CMD_SET_ATTR           =3D 56,
> +       PDS_VDPA_CMD_VQ_SET_STATE       =3D 57,
> +       PDS_VDPA_CMD_VQ_GET_STATE       =3D 58,
> +};
> +
> +/**
> + * struct pds_vdpa_cmd - generic command
> + * @opcode:    Opcode
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + */
> +struct pds_vdpa_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +};
> +
> +/**
> + * struct pds_vdpa_init_cmd - INIT command
> + * @opcode:    Opcode PDS_VDPA_CMD_INIT
> + * @vdpa_index: Index for vdpa subdevice
> + * @vf_id:     VF id
> + */
> +struct pds_vdpa_init_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +};
> +
> +/**
> + * struct pds_vdpa_ident - vDPA identification data
> + * @hw_features:       vDPA features supported by device
> + * @max_vqs:           max queues available (2 queues for a single queue=
pair)
> + * @max_qlen:          log(2) of maximum number of descriptors
> + * @min_qlen:          log(2) of minimum number of descriptors
> + *
> + * This struct is used in a DMA block that is set up for the PDS_VDPA_CM=
D_IDENT
> + * transaction.  Set up the DMA block and send the address in the IDENT =
cmd
> + * data, the DSC will write the ident information, then we can remove th=
e DMA
> + * block after reading the answer.  If the completion status is 0, then =
there
> + * is valid information, else there was an error and the data should be =
invalid.
> + */
> +struct pds_vdpa_ident {
> +       __le64 hw_features;
> +       __le16 max_vqs;
> +       __le16 max_qlen;
> +       __le16 min_qlen;
> +};
> +
> +/**
> + * struct pds_vdpa_ident_cmd - IDENT command
> + * @opcode:    Opcode PDS_VDPA_CMD_IDENT
> + * @rsvd:       Word boundary padding
> + * @vf_id:     VF id
> + * @len:       length of ident info DMA space
> + * @ident_pa:  address for DMA of ident info (struct pds_vdpa_ident)
> + *                     only used for this transaction, then forgotten by=
 DSC
> + */
> +struct pds_vdpa_ident_cmd {
> +       u8     opcode;
> +       u8     rsvd;
> +       __le16 vf_id;
> +       __le32 len;
> +       __le64 ident_pa;
> +};
> +
> +/**
> + * struct pds_vdpa_status_cmd - STATUS_UPDATE command
> + * @opcode:    Opcode PDS_VDPA_CMD_STATUS_UPDATE
> + * @vdpa_index: Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @status:    new status bits
> + */
> +struct pds_vdpa_status_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       u8     status;
> +};
> +
> +/**
> + * enum pds_vdpa_attr - List of VDPA device attributes
> + * @PDS_VDPA_ATTR_MAC:          MAC address
> + * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
> + */
> +enum pds_vdpa_attr {
> +       PDS_VDPA_ATTR_MAC          =3D 1,
> +       PDS_VDPA_ATTR_MAX_VQ_PAIRS =3D 2,
> +};
> +
> +/**
> + * struct pds_vdpa_setattr_cmd - SET_ATTR command
> + * @opcode:            Opcode PDS_VDPA_CMD_SET_ATTR
> + * @vdpa_index:                Index for vdpa subdevice
> + * @vf_id:             VF id
> + * @attr:              attribute to be changed (enum pds_vdpa_attr)
> + * @pad:               Word boundary padding
> + * @mac:               new mac address to be assigned as vdpa device add=
ress
> + * @max_vq_pairs:      new limit of virtqueue pairs
> + */
> +struct pds_vdpa_setattr_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       u8     attr;
> +       u8     pad[3];
> +       union {
> +               u8 mac[6];
> +               __le16 max_vq_pairs;
> +       } __packed;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_init_cmd - queue init command
> + * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id (bit0 clear =3D rx, bit0 set =3D tx, qid=3DN is =
ctrlq)
> + * @len:       log(2) of max descriptor count
> + * @desc_addr: DMA address of descriptor area
> + * @avail_addr:        DMA address of available descriptors (aka driver =
area)
> + * @used_addr: DMA address of used descriptors (aka device area)
> + * @intr_index:        interrupt index
> + */
> +struct pds_vdpa_vq_init_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +       __le16 len;
> +       __le64 desc_addr;
> +       __le64 avail_addr;
> +       __le64 used_addr;
> +       __le16 intr_index;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_init_comp - queue init completion
> + * @status:    Status of the command (enum pds_core_status_code)
> + * @hw_qtype:  HW queue type, used in doorbell selection
> + * @hw_qindex: HW queue index, used in doorbell selection
> + * @rsvd:      Word boundary padding
> + * @color:     Color bit
> + */
> +struct pds_vdpa_vq_init_comp {
> +       u8     status;
> +       u8     hw_qtype;
> +       __le16 hw_qindex;
> +       u8     rsvd[11];
> +       u8     color;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_reset_cmd - queue reset command
> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_RESET
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id
> + */
> +struct pds_vdpa_vq_reset_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +};
> +
> +/**
> + * struct pds_vdpa_set_features_cmd - set hw features
> + * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @rsvd:       Word boundary padding
> + * @features:  Feature bit mask
> + */
> +struct pds_vdpa_set_features_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le32 rsvd;
> +       __le64 features;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_set_state_cmd - set vq state
> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_SET_STATE
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id
> + * @avail:     Device avail index.
> + * @used:      Device used index.
> + *
> + * If the virtqueue uses packed descriptor format, then the avail and us=
ed
> + * index must have a wrap count.  The bits should be arranged like the u=
pper
> + * 16 bits in the device available notification data: 15 bit index, 1 bi=
t wrap.
> + */
> +struct pds_vdpa_vq_set_state_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +       __le16 avail;
> +       __le16 used;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_get_state_cmd - get vq state
> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_GET_STATE
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id
> + */
> +struct pds_vdpa_vq_get_state_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_get_state_comp - get vq state completion
> + * @status:    Status of the command (enum pds_core_status_code)
> + * @rsvd0:      Word boundary padding
> + * @avail:     Device avail index.
> + * @used:      Device used index.
> + * @rsvd:       Word boundary padding
> + * @color:     Color bit
> + *
> + * If the virtqueue uses packed descriptor format, then the avail and us=
ed
> + * index will have a wrap count.  The bits will be arranged like the "ne=
xt"
> + * part of device available notification data: 15 bit index, 1 bit wrap.
> + */
> +struct pds_vdpa_vq_get_state_comp {
> +       u8     status;
> +       u8     rsvd0;
> +       __le16 avail;
> +       __le16 used;
> +       u8     rsvd[9];
> +       u8     color;
> +};
> +
>  union pds_core_adminq_cmd {
>         u8     opcode;
>         u8     bytes[64];
> @@ -621,6 +872,18 @@ union pds_core_adminq_cmd {
>
>         struct pds_core_q_identify_cmd    q_ident;
>         struct pds_core_q_init_cmd        q_init;
> +
> +       struct pds_vdpa_cmd               vdpa;
> +       struct pds_vdpa_init_cmd          vdpa_init;
> +       struct pds_vdpa_ident_cmd         vdpa_ident;
> +       struct pds_vdpa_status_cmd        vdpa_status;
> +       struct pds_vdpa_setattr_cmd       vdpa_setattr;
> +       struct pds_vdpa_set_features_cmd  vdpa_set_features;
> +       struct pds_vdpa_vq_init_cmd       vdpa_vq_init;
> +       struct pds_vdpa_vq_reset_cmd      vdpa_vq_reset;
> +       struct pds_vdpa_vq_set_state_cmd  vdpa_vq_set_state;
> +       struct pds_vdpa_vq_get_state_cmd  vdpa_vq_get_state;
> +
>  };
>
>  union pds_core_adminq_comp {
> @@ -642,6 +905,9 @@ union pds_core_adminq_comp {
>
>         struct pds_core_q_identify_comp   q_ident;
>         struct pds_core_q_init_comp       q_init;
> +
> +       struct pds_vdpa_vq_init_comp      vdpa_vq_init;
> +       struct pds_vdpa_vq_get_state_comp vdpa_vq_get_state;
>  };
>
>  #ifndef __CHECKER__
> --
> 2.17.1
>


