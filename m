Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080796F24F7
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjD2OHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 10:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjD2OHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 10:07:33 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A37198A;
        Sat, 29 Apr 2023 07:07:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-24de923ef00so99213a91.3;
        Sat, 29 Apr 2023 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682777250; x=1685369250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkA/OpHNB5P87CBPybRbMah7voUWd4onYJPq0iCbZKw=;
        b=Sx8EkgOIKNSKw3spvb2nYDoAT3XXEILsH4viui5dcPWY6mhZkBCqq89QHPYwtGgjxy
         s0NQ5tuI0FCVqFz4F9fsXz//P09mMiPHj2HNeKxEG7T7A0J6iADkhfkqFHFUXpmUCLWX
         kKbnGo9XAqk+KV55WlyCRSO2K+WnaTwphg4L4JiNmy2uZ0Dr4yh6Pk/M87hrXll9vnrM
         OZHrh4oz0gRlRuMF31ZvIzanraKXhIP0g34ZewtGxn2UwaVMq1m5Tcm+WuuM4thMd6RN
         BsLv7hiH0/dlvNLW9iFVoL5Msyu9DcQz/qwqyHvZnYQyn0763IM+Gfnw+tjFbRWR099P
         iy4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682777250; x=1685369250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkA/OpHNB5P87CBPybRbMah7voUWd4onYJPq0iCbZKw=;
        b=j4BWuOT90OVWBKpAJVz81gcdkm8tHajOEUUxCpthPhLWjIVpNAExzwuiCyjP7wf1E2
         MnI8eDYkPf2y2BQWDR+ewiqE2vMR4wUBFUMjjq/bv10Kbz0EgG5c0G+oxDZx/c7/jH5B
         kSCeSEuu9qlhSKiT0kNnY+YTKFcZbxAfzPjEVXbUU0xz5bRNjAU9PeMqOQT8mtNJVk5F
         gC9vwrwYpOibY17l9Xb+bgXyDBk/V2TyTvwrZUtrSZVgoQoq8oM62FnugyPxcBDxq5s2
         TMMx/qw/6iLE1YTysWsw4bRB2O8j+PjN7VMeeoyC00i/XY3nuRraENN+Ytd21+NS9Myt
         65rQ==
X-Gm-Message-State: AC+VfDzaUg1O4IrQmjCpvpCqiPUnzooUd6Vu6Wb5p4QozlX3Yoq2iY44
        SZv9S7cSiOOgEcwYkZ/XyTw=
X-Google-Smtp-Source: ACHHUZ58/qduOdEBYYbQ3pkGAERlbjm77a2t2riVYrPYoGZW+4/zEDc/2SaVQDs+S7s7ylg9rxMCtw==
X-Received: by 2002:a17:90a:c784:b0:247:ad6d:7250 with SMTP id gn4-20020a17090ac78400b00247ad6d7250mr9164173pjb.12.1682777250150;
        Sat, 29 Apr 2023 07:07:30 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-86.three.co.id. [180.214.233.86])
        by smtp.gmail.com with ESMTPSA id h16-20020a17090aea9000b00247164c1947sm1046472pjz.0.2023.04.29.07.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 07:07:29 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 839EB1068BF; Sat, 29 Apr 2023 21:07:25 +0700 (WIB)
Date:   Sat, 29 Apr 2023 21:07:25 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Networking <netdev@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>
Subject: Re: iwlwifi broken in post-linux-6.3.0 after April 26
Message-ID: <ZE0kndhsXNBIb1g7@debian.me>
References: <20230429020951.082353595@lindbergh.monkeyblade.net>
 <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eCuRfp6dkc3SfFeY"
Content-Disposition: inline
In-Reply-To: <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eCuRfp6dkc3SfFeY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 29, 2023 at 01:22:03PM +0800, Jeff Chua wrote:
> Can't start wifi on latest linux git pull ... started happening 3 days ag=
o ...

Are you testing mainline?

Also Cc'ing networking and iwlwifi people.

>=20
> Is there a fix for this? Or shall I bisect? Wifi works by reverting
> back to released 6.3.0.

Certainly you should do bisection.

>=20
> Thanks,
> Jeff
>=20
>=20
> # wpa_supplicant -Dnl80211 -c wpa.conf -iwlan0
> wlwifi 0000:00:14.3: Failed to send RFI config cmd -5
> iwlwifi 0000:00:14.3: LED command failed: -5
> iwlwifi 0000:00:14.3: Failed to send MAC_CONFIG_CMD (action:1): -5
>=20
> # lsmod
> iwlmvm                352256  0
> mac80211              610304  1 iwlmvm
> iwlwifi               299008  1 iwlmvm
> cfg80211              417792  3 iwlmvm,iwlwifi,mac80211
> ax88179_178a           28672  0
>=20
> # dmesg
> iwlwifi 0000:00:14.3: Microcode SW error detected. Restarting 0x0.
> iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
> iwlwifi 0000:00:14.3: Transport status: 0x0000004B, valid: 6
> iwlwifi 0000:00:14.3: Loaded firmware version: 78.3bfdc55f.0
> so-a0-gf-a0-78.ucode
> iwlwifi 0000:00:14.3: 0x00000071 | NMI_INTERRUPT_UMAC_FATAL
> iwlwifi 0000:00:14.3: 0x000002F0 | trm_hw_status0
> iwlwifi 0000:00:14.3: 0x00000000 | trm_hw_status1
> iwlwifi 0000:00:14.3: 0x004DB13C | branchlink2
> iwlwifi 0000:00:14.3: 0x004D0D3A | interruptlink1
> iwlwifi 0000:00:14.3: 0x004D0D3A | interruptlink2
> iwlwifi 0000:00:14.3: 0x000157FE | data1
> iwlwifi 0000:00:14.3: 0x00000010 | data2
> iwlwifi 0000:00:14.3: 0x00000000 | data3
> iwlwifi 0000:00:14.3: 0x00000000 | beacon time
> iwlwifi 0000:00:14.3: 0x0002A2E7 | tsf low
> iwlwifi 0000:00:14.3: 0x00000000 | tsf hi
> iwlwifi 0000:00:14.3: 0x00000000 | time gp1
> iwlwifi 0000:00:14.3: 0x0003E5C3 | time gp2
> iwlwifi 0000:00:14.3: 0x00000001 | uCode revision type
> iwlwifi 0000:00:14.3: 0x0000004E | uCode version major
> iwlwifi 0000:00:14.3: 0x3BFDC55F | uCode version minor
> iwlwifi 0000:00:14.3: 0x00000370 | hw version
> iwlwifi 0000:00:14.3: 0x00480002 | board version
> iwlwifi 0000:00:14.3: 0x80B0FF00 | hcmd
> iwlwifi 0000:00:14.3: 0x00020000 | isr0
> iwlwifi 0000:00:14.3: 0x20000000 | isr1
> iwlwifi 0000:00:14.3: 0x58F00002 | isr2
> iwlwifi 0000:00:14.3: 0x00C3000C | isr3
> iwlwifi 0000:00:14.3: 0x00000000 | isr4
> iwlwifi 0000:00:14.3: 0x00000000 | last cmd Id
> iwlwifi 0000:00:14.3: 0x000157FE | wait_event
> iwlwifi 0000:00:14.3: 0x00000000 | l2p_control
> iwlwifi 0000:00:14.3: 0x00000000 | l2p_duration
> iwlwifi 0000:00:14.3: 0x00000000 | l2p_mhvalid
> iwlwifi 0000:00:14.3: 0x00000000 | l2p_addr_match
> iwlwifi 0000:00:14.3: 0x00000018 | lmpm_pmg_sel
> iwlwifi 0000:00:14.3: 0x00000000 | timestamp
> iwlwifi 0000:00:14.3: 0x0000103C | flow_handler
> iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
> iwlwifi 0000:00:14.3: Transport status: 0x0000004B, valid: 7
> iwlwifi 0000:00:14.3: 0x201002FD | ADVANCED_SYSASSERT
> iwlwifi 0000:00:14.3: 0x00000000 | umac branchlink1
> iwlwifi 0000:00:14.3: 0x8046E300 | umac branchlink2
> iwlwifi 0000:00:14.3: 0xC008191A | umac interruptlink1
> iwlwifi 0000:00:14.3: 0x00000000 | umac interruptlink2
> iwlwifi 0000:00:14.3: 0x0017020B | umac data1
> iwlwifi 0000:00:14.3: 0x00000308 | umac data2
> iwlwifi 0000:00:14.3: 0x00000304 | umac data3
> iwlwifi 0000:00:14.3: 0x0000004E | umac major
> iwlwifi 0000:00:14.3: 0x3BFDC55F | umac minor
> iwlwifi 0000:00:14.3: 0x0003E5BE | frame pointer
> iwlwifi 0000:00:14.3: 0xC0886C24 | stack pointer
> iwlwifi 0000:00:14.3: 0x0017020B | last host cmd
> iwlwifi 0000:00:14.3: 0x00000000 | isr status reg
> iwlwifi 0000:00:14.3: IML/ROM dump:
> iwlwifi 0000:00:14.3: 0x00000B03 | IML/ROM error/state
> iwlwifi 0000:00:14.3: 0x000081CD | IML/ROM data1
> iwlwifi 0000:00:14.3: 0x00000080 | IML/ROM WFPM_AUTH_KEY_0
> iwlwifi 0000:00:14.3: Fseq Registers:
> iwlwifi 0000:00:14.3: 0x60000100 | FSEQ_ERROR_CODE
> iwlwifi 0000:00:14.3: 0x003E0003 | FSEQ_TOP_INIT_VERSION
> iwlwifi 0000:00:14.3: 0x00190003 | FSEQ_CNVIO_INIT_VERSION
> iwlwifi 0000:00:14.3: 0x0000A652 | FSEQ_OTP_VERSION
> iwlwifi 0000:00:14.3: 0x00000003 | FSEQ_TOP_CONTENT_VERSION
> iwlwifi 0000:00:14.3: 0x4552414E | FSEQ_ALIVE_TOKEN
> iwlwifi 0000:00:14.3: 0x00080400 | FSEQ_CNVI_ID
> iwlwifi 0000:00:14.3: 0x00400410 | FSEQ_CNVR_ID
> iwlwifi 0000:00:14.3: 0x00080400 | CNVI_AUX_MISC_CHIP
> iwlwifi 0000:00:14.3: 0x00400410 | CNVR_AUX_MISC_CHIP
> iwlwifi 0000:00:14.3: 0x00009061 | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
> iwlwifi 0000:00:14.3: 0x00000061 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MI=
RROR
> iwlwifi 0000:00:14.3: UMAC CURRENT PC: 0xd05c18
> iwlwifi 0000:00:14.3: LMAC1 CURRENT PC: 0xd05c1c
> iwlwifi 0000:00:14.3: Starting mac, retry will be triggered anyway
> iwlwifi 0000:00:14.3: FW error in SYNC CMD RFI_CONFIG_CMD
> CPU: 6 PID: 22193 Comm: wpa_supplicant Tainted: G     U             6.3.0=
 #1
> Hardware name: LENOVO 21CCS1GL00/21CCS1GL00, BIOS N3AET72W (1.37 ) 03/02/=
2023
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x33/0x50
>  iwl_trans_txq_send_hcmd+0x33a/0x380 [iwlwifi]
>  ? destroy_sched_domains_rcu+0x20/0x20
>  iwl_trans_send_cmd+0x55/0xe0 [iwlwifi]
>  iwl_mvm_send_cmd+0xd/0x30 [iwlmvm]
>  iwl_rfi_send_config_cmd+0x8f/0xf0 [iwlmvm]
>  iwl_mvm_up+0x8c9/0x980 [iwlmvm]
>  __iwl_mvm_mac_start+0x181/0x1e0 [iwlmvm]
>  iwl_mvm_mac_start+0x3f/0x100 [iwlmvm]
>  drv_start+0x2c/0x50 [mac80211]
>  ieee80211_do_open+0x2f2/0x6b0 [mac80211]
>  ieee80211_open+0x62/0x80 [mac80211]
>  __dev_open+0xca/0x170
>  __dev_change_flags+0x1a1/0x210
>  dev_change_flags+0x1c/0x60
>  devinet_ioctl+0x555/0x790
>  inet_ioctl+0x116/0x1b0
>  ? netdev_name_node_lookup_rcu+0x58/0x70
>  ? dev_get_by_name_rcu+0x5/0x10
>  ? netdev_name_node_lookup_rcu+0x58/0x70
>  ? dev_get_by_name_rcu+0x5/0x10
>  ? dev_ioctl+0x34d/0x4c0
>  sock_do_ioctl+0x3a/0xe0
>  sock_ioctl+0x15a/0x2b0
>  ? __sys_recvmsg+0x51/0xa0
>  __x64_sys_ioctl+0x7d/0xa0
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7efcee3a0448
> Code: 00 00 48 8d 44 24 08 48 89 54 24 e0 48 89 44 24 c0 48 8d 44 24
> d0 48 89 44 24 c8 b8 10 00 00 00 c7 44 24 b8 10 00 00 00 0f 05 <41> 89
> c0 3d 00 f0 ff ff 77 0e 44 89 c0 c3 66 2e 0f 1f 84 00 00 00
> RSP: 002b:00007ffe400ff678 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007efcee3a0448
> RDX: 00007ffe400ff680 RSI: 0000000000008914 RDI: 0000000000000007
> RBP: 0000000000000007 R08: 0000000000000000 R09: 000000000078f4b0
> R10: e324395ae363498e R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000790a30 R14: 0000000000000002 R15: 0000000000000000
>  </TASK>

Thanks for the report. I'm adding it to regzbot:

#regzbot ^introduced v6.3..89d77f71f493a3
#regzbot title iwlwifi broken on 6.4 merge window

Grazie.

--=20
An old man doll... just what I always wanted! - Clara

--eCuRfp6dkc3SfFeY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZE0kmAAKCRD2uYlJVVFO
o2itAQCYf7FoFG44JkR/Puz/9O9H1Rp9ZE6MEu8TYvIEw5pICQEAtxCOaKJusNee
n0Od/FLcAeqfOvsr6uKZ+aNNdGANcgA=
=qk5p
-----END PGP SIGNATURE-----

--eCuRfp6dkc3SfFeY--
