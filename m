Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5B72D2264
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 05:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgLHEyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 23:54:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgLHEyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 23:54:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84nxYX064111;
        Tue, 8 Dec 2020 04:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1e3cV7XKyt5cBPHNeWYhYMHu3W87CKppja6U1Jvw5F4=;
 b=V+G180Fh0lHbcmydQJqS5i+cerb42SoRrRI9QCXlQMjyWKKfj0acXqExTQUiK+7OEtft
 OuMy/8L57grCegXY4FPi2mfpdUD9NETOrjU6XyLEGnB6yCKU9e30d2WSgQTsYBxq/cMN
 5junVfgiRpfFB5rc1EfDtZHP43anCs3FIrUtz16u4yPsKG0NCInMT5yeMTaPCX1MMJeq
 qZ1GHIcbwNatFRQ/tELhwJDJybfqjlIskC/pDoCLpTPJ2KTrod7PX9rst5aaRTC3xIQA
 veh/+mbPHLjYXfePq5oiUCHv2+7Gowf8M2KKiHFzojpZKSSSQD2meZy2nTRpI8CVh6TQ Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m0srp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:52:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ocFe155422;
        Tue, 8 Dec 2020 04:52:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 358kys9m8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:52:34 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B84qX4M159553;
        Tue, 8 Dec 2020 04:52:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 358kys9m7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:52:33 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B84qDZf015901;
        Tue, 8 Dec 2020 04:52:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:52:13 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        coreteam@netfilter.org, selinux@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>,
        linux-hardening@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, patches@opensource.cirrus.com,
        linux-fbdev@vger.kernel.org, keyrings@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-geode@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-ext4@vger.kernel.org,
        wcn36xx@lists.infradead.org, GR-everest-linux-l2@marvell.com,
        x86@kernel.org, linux-watchdog@vger.kernel.org,
        linux-media@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-atm-general@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-mediatek@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        samba-technical@lists.samba.org, ceph-devel@vger.kernel.org,
        drbd-dev@tron.linbit.com, intel-gfx@lists.freedesktop.org,
        dm-devel@redhat.com, linux-acpi@vger.kernel.org,
        linux-ide@vger.kernel.org, xen-devel@lists.xenproject.org,
        op-tee@lists.trustedfirmware.org, linux-hwmon@vger.kernel.org,
        linux-sctp@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-mtd@lists.infradead.org, linux-input@vger.kernel.org,
        linux-can@vger.kernel.org, rds-devel@oss.oracle.com,
        oss-drivers@netronome.com, tipc-discussion@lists.sourceforge.net,
        cluster-devel@redhat.com, linux-rdma@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        linux1394-devel@lists.sourceforge.net, alsa-devel@alsa-project.org,
        linux-i3c@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-afs@lists.infradead.org, nouveau@lists.freedesktop.org,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-mm@kvack.org,
        intel-wired-lan@lists.osuosl.org, linux-renesas-soc@vger.kernel.org
Subject: Re: (subset) [PATCH 000/141] Fix fall-through warnings for Clang
Date:   Mon,  7 Dec 2020 23:52:01 -0500
Message-Id: <160740299787.710.4201881220590518200.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=740 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 12:21:39 -0600, Gustavo A. R. Silva wrote:

> This series aims to fix almost all remaining fall-through warnings in
> order to enable -Wimplicit-fallthrough for Clang.
> 
> In preparation to enable -Wimplicit-fallthrough for Clang, explicitly
> add multiple break/goto/return/fallthrough statements instead of just
> letting the code fall through to the next case.
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[054/141] target: Fix fall-through warnings for Clang
          https://git.kernel.org/mkp/scsi/c/492096ecfa39

-- 
Martin K. Petersen	Oracle Linux Engineering
