Return-Path: <netdev+bounces-11047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D549F731505
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EC022802BB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0886FB1;
	Thu, 15 Jun 2023 10:16:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377BC3D75
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:16:35 +0000 (UTC)
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E6271C
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:16:33 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-39ab96e6aefso4991725b6e.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686824193; x=1689416193;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MWHqGDTZpLIdKsbxNJ27h4ZAV/Ogp4HBtSOv/yCTLnE=;
        b=RM1xA/IOppLKoAvkvfw0uhmfTiS4kc/IzJd/7B4x+/In+GdL2kApzyhF2lZLYM7XzI
         O4O1QCRsgaQdDFjhUC16rc/B77S9dWkfNCCXC83YJ1RBrlMQ+u0iafEQt82DL8xds0Va
         A9T6jV8Gp46CPdBZvgaTwTtw0J/qVmh7xZmx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686824193; x=1689416193;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MWHqGDTZpLIdKsbxNJ27h4ZAV/Ogp4HBtSOv/yCTLnE=;
        b=GQn9V20KXWs9EWmRguppgZaQVk3W/yh07bqX2mAWVJPTGPUyinlBwjsL+JauupicpB
         aUrQT18VtdwOMmCrWL7WTfVAJ/SJbBmvQTcPDT7OObJI6iMJV2f49QJMhARjeWsIT6QZ
         MXnaDvBoLTVtudZtZ6sfnXtmNw4TUforjMRCsqWcEgcDhVCViCSCvFVRqDQAM4kESKSK
         w9N3aoDX/IB5reR7zLb4t0Sqv7uoFO2UgPGH6QPzjPMWNWCCFHCKtHe7YSDHVICq4PT0
         rOCXeBopKGkaL81LF1CkFv/hsvnwdTfsp6UduXmVwafxRJzGbaYAKvsj8/B84kecpjI3
         fmqw==
X-Gm-Message-State: AC+VfDwraKK+pj85sJTnlMU6jX8SPPTU854Cx9Y4jzcJfr83Noz/OwRT
	1tzTfLEjxqZh/BgtJVNxpysvGUPF8yOWaHUywRZdzQ==
X-Google-Smtp-Source: ACHHUZ7hA2/Us4LylOw7dI2oS0wHf5UmopXMHcqRUlxX+faHA+J3md0RJ9anhI9dBdgpU7L28d/6bJI3foQs/t0WU3I=
X-Received: by 2002:a05:6808:2019:b0:39c:870a:cc07 with SMTP id
 q25-20020a056808201900b0039c870acc07mr16212277oiw.32.1686824192698; Thu, 15
 Jun 2023 03:16:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230615095447.8259-1-poros@redhat.com>
In-Reply-To: <20230615095447.8259-1-poros@redhat.com>
From: Pavan Chebbi <pavan.chebbi@broadcom.com>
Date: Thu, 15 Jun 2023 15:46:20 +0530
Message-ID: <CALs4sv28OwyRK7j+ZF55Hr=jAEn2X98zFPPN99tJ-ht=a8PfBw@mail.gmail.com>
Subject: Re: [PATCH net-next] devlink: report devlink_port_type_warn source device
To: Petr Oros <poros@redhat.com>
Cc: netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000d32db705fe285cf7"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000d32db705fe285cf7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 3:25=E2=80=AFPM Petr Oros <poros@redhat.com> wrote:
>
> devlink_port_type_warn is scheduled for port devlink and warning
> when the port type is not set. But from this warning it is not easy
> found out which device (driver) has no devlink port set.
>
> [ 3709.975552] Type was not set for devlink port.
> [ 3709.975579] WARNING: CPU: 1 PID: 13092 at net/devlink/leftover.c:6775 =
devlink_port_type_warn+0x11/0x20
> [ 3709.993967] Modules linked in: openvswitch nf_conncount nf_nat nf_conn=
track nf_defrag_ipv6 nf_defrag_ipv4 nfnetlink bluetooth rpcsec_gss_krb5 aut=
h_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs vhost_net vhost v=
host_iotlb tap tun bridge stp llc qrtr intel_rapl_msr intel_rapl_common i10=
nm_edac nfit libnvdimm x86_pkg_temp_thermal mlx5_ib intel_powerclamp corete=
mp dell_wmi ledtrig_audio sparse_keymap ipmi_ssif kvm_intel ib_uverbs rfkil=
l ib_core video kvm iTCO_wdt acpi_ipmi intel_vsec irqbypass ipmi_si iTCO_ve=
ndor_support dcdbas ipmi_devintf mei_me ipmi_msghandler rapl mei intel_csta=
te isst_if_mmio isst_if_mbox_pci dell_smbios intel_uncore isst_if_common i2=
c_i801 dell_wmi_descriptor wmi_bmof i2c_smbus intel_pch_thermal pcspkr acpi=
_power_meter xfs libcrc32c sd_mod sg nvme_tcp mgag200 i2c_algo_bit nvme_fab=
rics drm_shmem_helper drm_kms_helper nvme syscopyarea ahci sysfillrect sysi=
mgblt nvme_core fb_sys_fops crct10dif_pclmul libahci mlx5_core sfc crc32_pc=
lmul nvme_common drm
> [ 3709.994030]  crc32c_intel mtd t10_pi mlxfw libata tg3 mdio megaraid_sa=
s psample ghash_clmulni_intel pci_hyperv_intf wmi dm_multipath sunrpc dm_mi=
rror dm_region_hash dm_log dm_mod be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls =
libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi s=
csi_transport_iscsi fuse
> [ 3710.108431] CPU: 1 PID: 13092 Comm: kworker/1:1 Kdump: loaded Not tain=
ted 5.14.0-319.el9.x86_64 #1
> [ 3710.108435] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.8.2=
 09/14/2022
> [ 3710.108437] Workqueue: events devlink_port_type_warn
> [ 3710.108440] RIP: 0010:devlink_port_type_warn+0x11/0x20
> [ 3710.108443] Code: 84 76 fe ff ff 48 c7 03 20 0e 1a ad 31 c0 e9 96 fd f=
f ff 66 0f 1f 44 00 00 0f 1f 44 00 00 48 c7 c7 18 24 4e ad e8 ef 71 62 ff <=
0f> 0b c3 cc cc cc cc 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f6 87
> [ 3710.108445] RSP: 0018:ff3b6d2e8b3c7e90 EFLAGS: 00010282
> [ 3710.108447] RAX: 0000000000000000 RBX: ff366d6580127080 RCX: 000000000=
0000027
> [ 3710.108448] RDX: 0000000000000027 RSI: 00000000ffff86de RDI: ff366d753=
f41f8c8
> [ 3710.108449] RBP: ff366d658ff5a0c0 R08: ff366d753f41f8c0 R09: ff3b6d2e8=
b3c7e18
> [ 3710.108450] R10: 0000000000000001 R11: 0000000000000023 R12: ff366d753=
f430600
> [ 3710.108451] R13: ff366d753f436900 R14: 0000000000000000 R15: ff366d753=
f436905
> [ 3710.108452] FS:  0000000000000000(0000) GS:ff366d753f400000(0000) knlG=
S:0000000000000000
> [ 3710.108453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3710.108454] CR2: 00007f1c57bc74e0 CR3: 000000111d26a001 CR4: 000000000=
0773ee0
> [ 3710.108456] PKRU: 55555554
> [ 3710.108457] Call Trace:
> [ 3710.108458]  <TASK>
> [ 3710.108459]  process_one_work+0x1e2/0x3b0
> [ 3710.108466]  ? rescuer_thread+0x390/0x390
> [ 3710.108468]  worker_thread+0x50/0x3a0
> [ 3710.108471]  ? rescuer_thread+0x390/0x390
> [ 3710.108473]  kthread+0xdd/0x100
> [ 3710.108477]  ? kthread_complete_and_exit+0x20/0x20
> [ 3710.108479]  ret_from_fork+0x1f/0x30
> [ 3710.108485]  </TASK>
> [ 3710.108486] ---[ end trace 1b4b23cd0c65d6a0 ]---
>
> After patch:
> [  402.473064] ice 0000:41:00.0: Type was not set for devlink port.
> [  402.473064] ice 0000:41:00.1: Type was not set for devlink port.
>
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---

Looks good to me.
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>


> 2.41.0
>
>

--000000000000d32db705fe285cf7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKZJi7fd7x8Ma4CTC5ua80YEYQ853Yt+
MwANmCFGbvtiMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYx
NTEwMTYzM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAzz5zOkTIbQ9rQH5ed2Xyy3rIGh03zAf7XMLSuWhblybrJ9V2C
z2ORgXHWj3qtBF+89ofrGkFI9395D8tKaTvhnb63e4Llpr2fWsLnI2+ClGy7fVVygrXcCaOhtlNV
COorq8bwUoi1bFT7uhd2l4ocJn+skkSavAZga+rE+RGBGOx9iYxrrus+B3AOen5CEM+GHv4co+hf
cKRgGB1dG76lA1NXPQ7YWP+gLVap4BIVoAzi8n+tv1EoItYCa8zpZIGvadbzplCah6UJiH9KV3Ti
lytKjrZ9pjYqgbi23qGyu7JoII+/yYODaFsYonJiQXaBKcpzj25vQ8pn0taYUQ1v
--000000000000d32db705fe285cf7--

