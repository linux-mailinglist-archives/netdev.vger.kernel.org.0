Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED57B5B918F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIOAPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 20:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIOAPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 20:15:49 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B80DDE94;
        Wed, 14 Sep 2022 17:15:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MSd5Q27Lkz4xG8;
        Thu, 15 Sep 2022 10:15:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1663200939;
        bh=KfiMD+TDLvqv7kw67ac9jqZ3Xt6amXpenQw4Nb0P2J8=;
        h=Date:From:To:Cc:Subject:From;
        b=Mpcd2SMA6jggFKqcal9nGgBBm4XiKMmTuA2BoH2NQ+5r2o3kPqbahC+b2etrsuwAF
         Quj6FT8vJRnVHH4Aq4Z93ZPR0FPEIYBvlJK8blxIeBd8D9GwfPqoTB6dnzcZN2nl5R
         XVi3zo1KbyjsaYMq05QTpu0Pj+DWXhN8IF9gWkTSaiMTTg4pdxOULa+lPKLW/PD9eQ
         a6JAaqaWq9dLBI59i3rVPof5vJSZJp8iHf6+pNGKS2AIjUN6P1sBSnbhIemwOZBUay
         Zh8KcrnJqDVPFHWYk+axDC4URFJfeRNMYhYjQxO+1qLQVnIDf5vZkJbYTWXXLDycXR
         fFgarCl/ojQkA==
Date:   Thu, 15 Sep 2022 10:15:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Aurelien Aptel <aaptel@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the mlx5-next tree with the net-next
 tree
Message-ID: <20220915101516.1e99908a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_ewEq_0EXifW07Krq1TI2+b";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_ewEq_0EXifW07Krq1TI2+b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mlx5-next tree got conflicts in:

  include/linux/mlx5/device.h
  include/linux/mlx5/mlx5_ifc.h

between commit:

  8385c51ff5bc ("net/mlx5: Introduce MACsec Connect-X offload hardware bits=
 and structures")

from the net-next tree and commits:

  6182534c2678 ("net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumera=
tions")
  4ced81c02b03 ("net/mlx5: Add IFC bits and enums for crypto key")

from the mlx5-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/mlx5/device.h
index 2927810f172b,1288aee9d9aa..000000000000
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@@ -1197,10 -1226,11 +1226,12 @@@ enum mlx5_cap_type=20
  	MLX5_CAP_VDPA_EMULATION =3D 0x13,
  	MLX5_CAP_DEV_EVENT =3D 0x14,
  	MLX5_CAP_IPSEC,
+ 	MLX5_CAP_DEV_NVMEOTCP =3D 0x19,
  	MLX5_CAP_DEV_SHAMPO =3D 0x1d,
 +	MLX5_CAP_MACSEC =3D 0x1f,
  	MLX5_CAP_GENERAL_2 =3D 0x20,
  	MLX5_CAP_PORT_SELECTION =3D 0x25,
+ 	MLX5_CAP_ADV_VIRTUALIZATION =3D 0x26,
  	/* NUM OF CAP Types */
  	MLX5_CAP_NUM
  };
@@@ -1447,9 -1485,14 +1486,17 @@@ enum mlx5_qcam_feature_groups=20
  #define MLX5_CAP_DEV_SHAMPO(mdev, cap)\
  	MLX5_GET(shampo_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_SHAMPO], cap)
 =20
 +#define MLX5_CAP_MACSEC(mdev, cap)\
 +	MLX5_GET(macsec_cap, (mdev)->caps.hca[MLX5_CAP_MACSEC]->cur, cap)
 +
+ #define MLX5_CAP_DEV_NVMEOTCP(mdev, cap)\
+ 	MLX5_GET(nvmeotcp_cap, \
+ 		 (mdev)->caps.hca[MLX5_CAP_DEV_NVMEOTCP]->cur, cap)
+=20
+ #define MLX5_CAP64_DEV_NVMEOTCP(mdev, cap)\
+ 	MLX5_GET64(nvmeotcp_cap, \
+ 		   (mdev)->caps.hca[MLX5_CAP_DEV_NVMEOTCP]->cur, cap)
+=20
  enum {
  	MLX5_CMD_STAT_OK			=3D 0x0,
  	MLX5_CMD_STAT_INT_ERR			=3D 0x1,
diff --cc include/linux/mlx5/mlx5_ifc.h
index 8decbf9a7bdd,3fb7b0d6cbb5..000000000000
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@@ -3323,7 -3382,8 +3410,9 @@@ union mlx5_ifc_hca_cap_union_bits=20
  	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
  	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
  	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 +	struct mlx5_ifc_macsec_cap_bits macsec_cap;
+ 	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
+ 	struct mlx5_ifc_crypto_cap_bits crypto_cap;
  	u8         reserved_at_0[0x8000];
  };
 =20
@@@ -11506,8 -11588,9 +11624,10 @@@ enum=20
  	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D 0xc,
  	MLX5_GENERAL_OBJECT_TYPES_IPSEC =3D 0x13,
  	MLX5_GENERAL_OBJECT_TYPES_SAMPLER =3D 0x20,
+ 	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE =3D 0x21,
  	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO =3D 0x24,
 +	MLX5_GENERAL_OBJECT_TYPES_MACSEC =3D 0x27,
+ 	MLX5_GENERAL_OBJECT_TYPES_INT_KEK =3D 0x47,
  };
 =20
  enum {
@@@ -11558,67 -11641,38 +11678,99 @@@ struct mlx5_ifc_modify_ipsec_obj_in_b=
it
  	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
  };
 =20
 +struct mlx5_ifc_macsec_aso_bits {
 +	u8    valid[0x1];
 +	u8    reserved_at_1[0x1];
 +	u8    mode[0x2];
 +	u8    window_size[0x2];
 +	u8    soft_lifetime_arm[0x1];
 +	u8    hard_lifetime_arm[0x1];
 +	u8    remove_flow_enable[0x1];
 +	u8    epn_event_arm[0x1];
 +	u8    reserved_at_a[0x16];
 +
 +	u8    remove_flow_packet_count[0x20];
 +
 +	u8    remove_flow_soft_lifetime[0x20];
 +
 +	u8    reserved_at_60[0x80];
 +
 +	u8    mode_parameter[0x20];
 +
 +	u8    replay_protection_window[8][0x20];
 +};
 +
 +struct mlx5_ifc_macsec_offload_obj_bits {
 +	u8    modify_field_select[0x40];
 +
 +	u8    confidentiality_en[0x1];
 +	u8    reserved_at_41[0x1];
 +	u8    esn_en[0x1];
 +	u8    esn_overlap[0x1];
 +	u8    reserved_at_44[0x2];
 +	u8    confidentiality_offset[0x2];
 +	u8    reserved_at_48[0x4];
 +	u8    aso_return_reg[0x4];
 +	u8    reserved_at_50[0x10];
 +
 +	u8    esn_msb[0x20];
 +
 +	u8    reserved_at_80[0x8];
 +	u8    dekn[0x18];
 +
 +	u8    reserved_at_a0[0x20];
 +
 +	u8    sci[0x40];
 +
 +	u8    reserved_at_100[0x8];
 +	u8    macsec_aso_access_pd[0x18];
 +
 +	u8    reserved_at_120[0x60];
 +
 +	u8    salt[3][0x20];
 +
 +	u8    reserved_at_1e0[0x20];
 +
 +	struct mlx5_ifc_macsec_aso_bits macsec_aso;
 +};
 +
 +struct mlx5_ifc_create_macsec_obj_in_bits {
 +	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
 +	struct mlx5_ifc_macsec_offload_obj_bits macsec_object;
 +};
 +
+ struct mlx5_ifc_wrapped_dek_bits {
+ 	u8         gcm_iv[0x60];
+=20
+ 	u8         reserved_at_60[0x20];
+=20
+ 	u8         const0[0x1];
+ 	u8         key_size[0x1];
+ 	u8         reserved_at_82[0x2];
+ 	u8         key2_invalid[0x1];
+ 	u8         reserved_at_85[0x3];
+ 	u8         pd[0x18];
+=20
+ 	u8         key_purpose[0x5];
+ 	u8         reserved_at_a5[0x13];
+ 	u8         kek_id[0x8];
+=20
+ 	u8         reserved_at_c0[0x40];
+=20
+ 	u8         key1[0x8][0x20];
+=20
+ 	u8         key2[0x8][0x20];
+=20
+ 	u8         reserved_at_300[0x40];
+=20
+ 	u8         const1[0x1];
+ 	u8         reserved_at_341[0x1f];
+=20
+ 	u8         reserved_at_360[0x20];
+=20
+ 	u8         auth_tag[0x80];
+ };
+=20
  struct mlx5_ifc_encryption_key_obj_bits {
  	u8         modify_field_select[0x40];
 =20
@@@ -11736,10 -11846,20 +11944,21 @@@ enum=20
  enum {
  	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS =3D 0x1,
  	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC =3D 0x2,
 +	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC =3D 0x4,
  };
 =20
- struct mlx5_ifc_tls_static_params_bits {
+ enum {
+ 	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS               =3D 0x1,
+ 	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP           =3D 0x2,
+ 	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP_WITH_TLS  =3D 0x3,
+ };
+=20
+ enum {
+ 	MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR  =3D 0x0,
+ 	MLX5_TRANSPORT_STATIC_PARAMS_TI_TARGET     =3D 0x1,
+ };
+=20
+ struct mlx5_ifc_transport_static_params_bits {
  	u8         const_2[0x2];
  	u8         tls_version[0x4];
  	u8         const_1[0x2];

--Sig_/_ewEq_0EXifW07Krq1TI2+b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMibpQACgkQAVBC80lX
0GzUaQgAiyCI7w3qkpk9aGLVytEebELGAD8ZHPGJe8sL2Oaq9MOqKoKc+LXHUs/v
fTi7Tmly4pTPxZmNHO8nHDHfJFMcZgPsB5buDo+Ho6w+Mfk3wst0I1MkMNhFP4gm
udsR4tU3ppPQCchyV76VHwjWI9+i3NrZtBScmLfRp53F46NMm6/1D2d0cmUXmqP7
WsWENa/uI2gy8UR6IZHrKmanOLS05EVLSx7fGxJruAtcI9k3Nw2ovZSbJNtxwsIx
wqp17mdmEoz0qsH8EgSMkCLpD9iNoiHxsMoAdLVm5rfTDrkutFb7Nkt3EflGpPR5
VLvNs7jA7+z2Wi/aLcrgNuOI83bBWg==
=+oAb
-----END PGP SIGNATURE-----

--Sig_/_ewEq_0EXifW07Krq1TI2+b--
