Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D99656713
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 04:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiL0DUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 22:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiL0DUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 22:20:23 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134F4EAF
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 19:20:23 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id bp44so7051118qtb.0
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 19:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j9TqouaQ4dSLX7fij0qvoaDsqo1Fmk/+SdehhwaPet0=;
        b=CgI5cYJdpDsmP6F88HCYxdFWmTPKwGuUds79vl1nhl7s58e1voPAUuOuoYCFkSDIBp
         lxz/td7S1Idf7qeZZAhtzoIvb7NUex2YqjbgIW3T2QoPLQbx4cvNZ1g9J1aQ6/nFwhez
         PFQ1VJd8HpRaiCBCkFGT0jkoJxExgzh7p+WVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9TqouaQ4dSLX7fij0qvoaDsqo1Fmk/+SdehhwaPet0=;
        b=QTRdZZlc9JU8T0eBJCQD4XSEiXkerd/ZKdIOynBwVSZWFKKYiiKIFD1Nr4Mi1Pdnmw
         l2VcavC4x9SRwmH6/QjTeLZBjTNSxGzzZJ8zo3kkMaZmbZLVH7XwEDazideZ8ABjkI5f
         ls3l3PZNzic13rJBhni4sQIvcbQak6lY5zb1n3QIsycTMAK+VR+YCxSdsC/PXqSUtog/
         brPkLr+tD2CvcUDpW+ZJ6ZX2ldYtlVvJEyeXUcozXpnf9M/wBREby1yp5ehXb6OG1s4p
         A2ZDROelkhdvagUofH7JJgxAOc1AVtck+TMxyTYzEW2nif93BTpXjI4tvm8dQYq6rgJl
         73Mw==
X-Gm-Message-State: AFqh2koZc7WZim9pg+H7E6ZeLTsVOZ1S4FX/pH0w+I7O2ERrTCVTZhMu
        MiB4XILXGG3lX2O/DW6S2DK4bmJzKskgDNmx
X-Google-Smtp-Source: AMrXdXsgSrMI45aMuhPW/0ggSrnsNoDq1enJ25pQz65IDtvux5K9nw/fsPsg49xMiXEma5kOGiDfrQ==
X-Received: by 2002:ac8:544c:0:b0:3a9:8561:429a with SMTP id d12-20020ac8544c000000b003a98561429amr22004402qtq.26.1672111221592;
        Mon, 26 Dec 2022 19:20:21 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fa11-20020a05622a4ccb00b003a68fe872a5sm7751262qtb.96.2022.12.26.19.20.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Dec 2022 19:20:20 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bpf@vger.kernel.org, gospo@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net 1/5] bnxt_en: fix devlink port registration to netdev
Date:   Mon, 26 Dec 2022 22:19:36 -0500
Message-Id: <1672111180-19463-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1672111180-19463-1-git-send-email-michael.chan@broadcom.com>
References: <1672111180-19463-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007055b205f0c6bb68"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007055b205f0c6bb68

From: Vikas Gupta <vikas.gupta@broadcom.com>

We don't register a devlink port in case of a VF so
avoid setting the devlink pointer to netdev.
Also, SET_NETDEV_DEVLINK_PORT has to be moved
so that we determine whether the device is PF/VF first.

This fixes the NULL pointer dereference of devlink_port->devlink
when creating VFs:

BUG: kernel NULL pointer dereference, address: 0000000000000160
PGD 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 14 PID: 388 Comm: kworker/14:1 Kdump: loaded Not tainted 6.1.0-rc8 #5
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.3.8 08/31/2021
Workqueue: events work_for_cpu_fn
RIP: 0010:devlink_nl_port_handle_size+0xb/0x50
Code: 83 c4 10 5b 5d c3 cc cc cc cc b8 a6 ff ff ff eb de e8 c9 59 21 00 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 53 48 8b 47 20 <48> 8b a8 60 01 00 00 48 8b 45 60 48 8b 38 e8 92 90 1a 00 48 8b 7d
RSP: 0018:ff4fe5394846fcd8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000794 RCX: 0000000000000000
RDX: ff1f129683a30a40 RSI: 0000000000000008 RDI: ff1f1296bb496188
RBP: 0000000000000334 R08: 0000000000000cc0 R09: 0000000000000000
R10: ff1f1296bb494298 R11: ffffffffffffffc0 R12: 0000000000000000
R13: 0000000000000000 R14: ff1f1296bb494000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ff1f129e5fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000160 CR3: 000000131f610006 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 if_nlmsg_size+0x14a/0x220
 rtmsg_ifinfo_build_skb+0x3c/0x100
 rtmsg_ifinfo+0x9c/0xc0
 register_netdevice+0x59d/0x670
 register_netdev+0x1c/0x40
 bnxt_init_one+0x674/0xa60 [bnxt_en]
 local_pci_probe+0x42/0x80
 work_for_cpu_fn+0x13/0x20
 process_one_work+0x1e2/0x3b0
 ? rescuer_thread+0x390/0x390
 worker_thread+0x1c4/0x3a0
 ? rescuer_thread+0x390/0x390
 kthread+0xd6/0x100
 ? kthread_complete_and_exit+0x20/0x20

Fixes: ac73d4bf2cda ("net: make drivers to use SET_NETDEV_DEVLINK_PORT to set devlink_port")
Cc: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4c7d07c684c4..93d32b333007 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13591,7 +13591,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	bp = netdev_priv(dev);
-	SET_NETDEV_DEVLINK_PORT(dev, &bp->dl_port);
 	bp->board_idx = ent->driver_data;
 	bp->msg_enable = BNXT_DEF_MSG_ENABLE;
 	bnxt_set_max_func_irqs(bp, max_irqs);
@@ -13599,6 +13598,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (bnxt_vf_pciid(bp->board_idx))
 		bp->flags |= BNXT_FLAG_VF;
 
+	/* No devlink port registration in case of a VF */
+	if (BNXT_PF(bp))
+		SET_NETDEV_DEVLINK_PORT(dev, &bp->dl_port);
+
 	if (pdev->msix_cap)
 		bp->flags |= BNXT_FLAG_MSIX_CAP;
 
-- 
2.18.1


--0000000000007055b205f0c6bb68
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPaVeBpQ/jxQwZnY/Lk+kdT94nWYjW6m
0G6+J5hgzTF1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIy
NzAzMjAyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCXJmIWZf3nh+PmTqP6L5BKmO0VXTgKH9XzRse6rIrKOpm9GJHK
jJsf5OMMTyYiA5dDYQhKsQKYvCyYvUrx4XAHrNpj+NYGJh6T0nyYya8UIkLEpa31m2Rcnki3KeNh
/BdwheZFqg1QYgfYqG+O9L30MtEAWfV32j+H9Q2qLRtfuQumX9L0Yo5lq/5V+juxi5wz48iCkNjJ
SKZlIAPiVB/K/jcsMMD1isiTWXzxz63FYFThMQgs8dQyCWPpnjkR3BfjAbZBU2HgM9HTlymKqlC3
fyiqQvShBOdOkzlaJ3pHblQaIQgLevM/cgbCm1jkMLGi3BKortbSwLqjhtutUloF
--0000000000007055b205f0c6bb68--
