Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8D694E28
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfHSTar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:30:47 -0400
Received: from mail-eopbgr700100.outbound.protection.outlook.com ([40.107.70.100]:39841
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbfHSTaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:30:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQaRWwW8mVcd6j9wcE6XiUWikqbJLIm8L148sVcC0D/NIQPXeNpfOCoO9wXUb1yDFu6hbIuKFcTlY8WtVaBxeKfAcM9TIzOZby8+mo1z2Qj68eXWQ5xWgKyg/Rav5/yervUX7eXp5II7963/OBh6f+prax9H0buyvT8hnMZJ4SmBeAqpDMdQKJasyhX+I+NUZFAiiD0TtG88ZbMpO5QnDPc/skrkZ3F1pmIupV3cgTsiexLx3kdtmo4U88MgRo/kTAqoluuIaLZwp1ENE+hrie3MN+sPV2yQRKyStDrQPRAiBUZ7HViA3AedOqpcnwWIeWdjO5G57n+t3D75BqxX9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8//GOpJEL/Hp72jQ11NhDe6pU7e08emO3MeJRroTew=;
 b=OrYmp5+Ej/KHdyVlzPIXVE0XyL6p0Pqh4gXK6na7W/Q+Pexnmt1iN/jRNZeucfyzngYlVoPwgIi0YyoCvOrfBirDfBTKNFYZG5RraFhcGUyU7bofiaovXWynLto+rBF1ACSHwt/YV3aM5iKwflRrmhGvVPsY7d/bpgZcx+n4qcmByppJTZIVM09byC2P+Suv0vpCfkIPOJO2L1YrlbXbu4LGudC0yWOgbU4G8KHAtXUVXnzcMAisoy4eEoe0NzEm/oSzNxS9qDfGVnxJky3Wnao25EI6fCuWBqAtW5M0cs653imHh1Ygbm3589DhNw8mUpojeDX6LmSWw4jpzyYKYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8//GOpJEL/Hp72jQ11NhDe6pU7e08emO3MeJRroTew=;
 b=Y/6BUesxonBV9aQNpTRJcOhlfU07LJWjspKPBsz0zfMy8LIFWtFzjo2qYjC9WZtMFrFplDo3TpC10Wpm6uBsBXCQT063S5BIfh1VtViXkoEfBm9bzeWCufhGFgQnAd41VMtg7ouLv8oDrBDsqxhYBQ6g1a5BhcgjLe92AGE8htI=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:43 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:43 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>
Subject: [PATCH net-next,v2 1/6] PCI: hv: Add a paravirtual backchannel in
 software
Thread-Topic: [PATCH net-next,v2 1/6] PCI: hv: Add a paravirtual backchannel
 in software
Thread-Index: AQHVVsSXnUJJ5Z+GgkSUvZ2IfjAJJQ==
Date:   Mon, 19 Aug 2019 19:30:42 +0000
Message-ID: <1566242976-108801-2-git-send-email-haiyangz@microsoft.com>
References: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d10c461d-295c-4f27-c19b-08d724dbb991
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1145B80AD63871EB76CDB694ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(14444005)(76176011)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(11346002)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(107886003)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(30864003)(10290500003)(316002)(446003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4FwmDvwyhLSiZUm3EEwJEJMQWmhOFuKOuCe2FZW+inSNDVEGKVQmemVII/9c7CzdqEfi2p2i07V1LsM5PfOtg9a8MKQhSqrJVy6+OiPn9grgZG5p9U6didCIZOJ+NZ2monSJFeTpzgtfmddfhCKLfCKKEiZynU4n50OrQVflPmGVdKbOzm2NAbRqIlKuMUkFO4Xz7Q/s78hOIlIgZiNpXoyYcIh5iEpKadrp+4y0T+cv5HXUdBbP7yMYUjv/FvjQ1dBSPJuXzb1HVAhE9A04L3xL+v9KKyRbKmBXV6c40w/xGxdlm6UgssAr41o4ZFMag6EtwunAP9o4QKoJIGWjxbU2B8WFgkcTd1H5aTn0bfYCrc4y/fM9HMIpBZuc+n71zVi9DuQegKv4iwxS7xumwOGxnmwUGsnl373/z2apQr8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10c461d-295c-4f27-c19b-08d724dbb991
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:42.8468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7mC2cGcgoSfUIkH9o+K+a87mS0akg86WCtw3xyYcjURWeE8oB2NC4YTZaZzHcs+t87ALV67y5df5UtXkbRpjsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

Windows SR-IOV provides a backchannel mechanism in software for communicati=
on
between a VF driver and a PF driver.  These "configuration blocks" are
similar in concept to PCI configuration space, but instead of doing reads a=
nd
writes in 32-bit chunks through a very slow path, packets of up to 128 byte=
s
can be sent or received asynchronously.

Nearly every SR-IOV device contains just such a communications channel in
hardware, so using this one in software is usually optional.  Using the
software channel, however, allows driver implementers to leverage software
tools that fuzz the communications channel looking for vulnerabilities.

The usage model for these packets puts the responsibility for reading or
writing on the VF driver.  The VF driver sends a read or a write packet,
indicating which "block" is being referred to by number.

If the PF driver wishes to initiate communication, it can "invalidate" one =
or
more of the first 64 blocks.  This invalidation is delivered via a callback
supplied by the VF driver by this driver.

No protocol is implied, except that supplied by the PF and VF drivers.

Signed-off-by: Jake Oshins <jakeo@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/pci/controller/pci-hyperv.c | 302 ++++++++++++++++++++++++++++++++=
++++
 include/linux/hyperv.h              |  15 ++
 2 files changed, 317 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/p=
ci-hyperv.c
index 40b6254..57adeca 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -365,6 +365,39 @@ struct pci_delete_interrupt {
 	struct tran_int_desc int_desc;
 } __packed;
=20
+/*
+ * Note: the VM must pass a valid block id, wslot and bytes_requested.
+ */
+struct pci_read_block {
+	struct pci_message message_type;
+	u32 block_id;
+	union win_slot_encoding wslot;
+	u32 bytes_requested;
+} __packed;
+
+struct pci_read_block_response {
+	struct vmpacket_descriptor hdr;
+	u32 status;
+	u8 bytes[HV_CONFIG_BLOCK_SIZE_MAX];
+} __packed;
+
+/*
+ * Note: the VM must pass a valid block id, wslot and byte_count.
+ */
+struct pci_write_block {
+	struct pci_message message_type;
+	u32 block_id;
+	union win_slot_encoding wslot;
+	u32 byte_count;
+	u8 bytes[HV_CONFIG_BLOCK_SIZE_MAX];
+} __packed;
+
+struct pci_dev_inval_block {
+	struct pci_incoming_message incoming;
+	union win_slot_encoding wslot;
+	u64 block_mask;
+} __packed;
+
 struct pci_dev_incoming {
 	struct pci_incoming_message incoming;
 	union win_slot_encoding wslot;
@@ -499,6 +532,9 @@ struct hv_pci_dev {
 	struct hv_pcibus_device *hbus;
 	struct work_struct wrk;
=20
+	void (*block_invalidate)(void *context, u64 block_mask);
+	void *invalidate_context;
+
 	/*
 	 * What would be observed if one wrote 0xFFFFFFFF to a BAR and then
 	 * read it back, for each of the BAR offsets within config space.
@@ -817,6 +853,256 @@ static int hv_pcifront_write_config(struct pci_bus *b=
us, unsigned int devfn,
 	.write =3D hv_pcifront_write_config,
 };
=20
+/*
+ * Paravirtual backchannel
+ *
+ * Hyper-V SR-IOV provides a backchannel mechanism in software for
+ * communication between a VF driver and a PF driver.  These
+ * "configuration blocks" are similar in concept to PCI configuration spac=
e,
+ * but instead of doing reads and writes in 32-bit chunks through a very s=
low
+ * path, packets of up to 128 bytes can be sent or received asynchronously=
.
+ *
+ * Nearly every SR-IOV device contains just such a communications channel =
in
+ * hardware, so using this one in software is usually optional.  Using the
+ * software channel, however, allows driver implementers to leverage softw=
are
+ * tools that fuzz the communications channel looking for vulnerabilities.
+ *
+ * The usage model for these packets puts the responsibility for reading o=
r
+ * writing on the VF driver.  The VF driver sends a read or a write packet=
,
+ * indicating which "block" is being referred to by number.
+ *
+ * If the PF driver wishes to initiate communication, it can "invalidate" =
one or
+ * more of the first 64 blocks.  This invalidation is delivered via a call=
back
+ * supplied by the VF driver by this driver.
+ *
+ * No protocol is implied, except that supplied by the PF and VF drivers.
+ */
+
+struct hv_read_config_compl {
+	struct hv_pci_compl comp_pkt;
+	void *buf;
+	unsigned int len;
+	unsigned int bytes_returned;
+};
+
+/**
+ * hv_pci_read_config_compl() - Invoked when a response packet
+ * for a read config block operation arrives.
+ * @context:		Identifies the read config operation
+ * @resp:		The response packet itself
+ * @resp_packet_size:	Size in bytes of the response packet
+ */
+static void hv_pci_read_config_compl(void *context, struct pci_response *r=
esp,
+				     int resp_packet_size)
+{
+	struct hv_read_config_compl *comp =3D context;
+	struct pci_read_block_response *read_resp =3D
+		(struct pci_read_block_response *)resp;
+	unsigned int data_len, hdr_len;
+
+	hdr_len =3D offsetof(struct pci_read_block_response, bytes);
+	if (resp_packet_size < hdr_len) {
+		comp->comp_pkt.completion_status =3D -1;
+		goto out;
+	}
+
+	data_len =3D resp_packet_size - hdr_len;
+	if (data_len > 0 && read_resp->status =3D=3D 0) {
+		comp->bytes_returned =3D min(comp->len, data_len);
+		memcpy(comp->buf, read_resp->bytes, comp->bytes_returned);
+	} else {
+		comp->bytes_returned =3D 0;
+	}
+
+	comp->comp_pkt.completion_status =3D read_resp->status;
+out:
+	complete(&comp->comp_pkt.host_event);
+}
+
+/**
+ * hv_read_config_block() - Sends a read config block request to
+ * the back-end driver running in the Hyper-V parent partition.
+ * @pdev:		The PCI driver's representation for this device.
+ * @buf:		Buffer into which the config block will be copied.
+ * @len:		Size in bytes of buf.
+ * @block_id:		Identifies the config block which has been requested.
+ * @bytes_returned:	Size which came back from the back-end driver.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int hv_read_config_block(struct pci_dev *pdev, void *buf, unsigned int len=
,
+			 unsigned int block_id, unsigned int *bytes_returned)
+{
+	struct hv_pcibus_device *hbus =3D
+		container_of(pdev->bus->sysdata, struct hv_pcibus_device,
+			     sysdata);
+	struct {
+		struct pci_packet pkt;
+		char buf[sizeof(struct pci_read_block)];
+	} pkt;
+	struct hv_read_config_compl comp_pkt;
+	struct pci_read_block *read_blk;
+	int ret;
+
+	if (len =3D=3D 0 || len > HV_CONFIG_BLOCK_SIZE_MAX)
+		return -EINVAL;
+
+	init_completion(&comp_pkt.comp_pkt.host_event);
+	comp_pkt.buf =3D buf;
+	comp_pkt.len =3D len;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.pkt.completion_func =3D hv_pci_read_config_compl;
+	pkt.pkt.compl_ctxt =3D &comp_pkt;
+	read_blk =3D (struct pci_read_block *)&pkt.pkt.message;
+	read_blk->message_type.type =3D PCI_READ_BLOCK;
+	read_blk->wslot.slot =3D devfn_to_wslot(pdev->devfn);
+	read_blk->block_id =3D block_id;
+	read_blk->bytes_requested =3D len;
+
+	ret =3D vmbus_sendpacket(hbus->hdev->channel, read_blk,
+			       sizeof(*read_blk), (unsigned long)&pkt.pkt,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (ret)
+		return ret;
+
+	ret =3D wait_for_response(hbus->hdev, &comp_pkt.comp_pkt.host_event);
+	if (ret)
+		return ret;
+
+	if (comp_pkt.comp_pkt.completion_status !=3D 0 ||
+	    comp_pkt.bytes_returned =3D=3D 0) {
+		dev_err(&hbus->hdev->device,
+			"Read Config Block failed: 0x%x, bytes_returned=3D%d\n",
+			comp_pkt.comp_pkt.completion_status,
+			comp_pkt.bytes_returned);
+		return -EIO;
+	}
+
+	*bytes_returned =3D comp_pkt.bytes_returned;
+	return 0;
+}
+EXPORT_SYMBOL(hv_read_config_block);
+
+/**
+ * hv_pci_write_config_compl() - Invoked when a response packet for a writ=
e
+ * config block operation arrives.
+ * @context:		Identifies the write config operation
+ * @resp:		The response packet itself
+ * @resp_packet_size:	Size in bytes of the response packet
+ */
+static void hv_pci_write_config_compl(void *context, struct pci_response *=
resp,
+				      int resp_packet_size)
+{
+	struct hv_pci_compl *comp_pkt =3D context;
+
+	comp_pkt->completion_status =3D resp->status;
+	complete(&comp_pkt->host_event);
+}
+
+/**
+ * hv_write_config_block() - Sends a write config block request to the
+ * back-end driver running in the Hyper-V parent partition.
+ * @pdev:		The PCI driver's representation for this device.
+ * @buf:		Buffer from which the config block will	be copied.
+ * @len:		Size in bytes of buf.
+ * @block_id:		Identifies the config block which is being written.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int hv_write_config_block(struct pci_dev *pdev, void *buf, unsigned int le=
n,
+			  unsigned int block_id)
+{
+	struct hv_pcibus_device *hbus =3D
+		container_of(pdev->bus->sysdata, struct hv_pcibus_device,
+			     sysdata);
+	struct {
+		struct pci_packet pkt;
+		char buf[sizeof(struct pci_write_block)];
+		u32 reserved;
+	} pkt;
+	struct hv_pci_compl comp_pkt;
+	struct pci_write_block *write_blk;
+	u32 pkt_size;
+	int ret;
+
+	if (len =3D=3D 0 || len > HV_CONFIG_BLOCK_SIZE_MAX)
+		return -EINVAL;
+
+	init_completion(&comp_pkt.host_event);
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.pkt.completion_func =3D hv_pci_write_config_compl;
+	pkt.pkt.compl_ctxt =3D &comp_pkt;
+	write_blk =3D (struct pci_write_block *)&pkt.pkt.message;
+	write_blk->message_type.type =3D PCI_WRITE_BLOCK;
+	write_blk->wslot.slot =3D devfn_to_wslot(pdev->devfn);
+	write_blk->block_id =3D block_id;
+	write_blk->byte_count =3D len;
+	memcpy(write_blk->bytes, buf, len);
+	pkt_size =3D offsetof(struct pci_write_block, bytes) + len;
+	/*
+	 * This quirk is required on some hosts shipped around 2018, because
+	 * these hosts don't check the pkt_size correctly (new hosts have been
+	 * fixed since early 2019). The quirk is also safe on very old hosts
+	 * and new hosts, because, on them, what really matters is the length
+	 * specified in write_blk->byte_count.
+	 */
+	pkt_size +=3D sizeof(pkt.reserved);
+
+	ret =3D vmbus_sendpacket(hbus->hdev->channel, write_blk, pkt_size,
+			       (unsigned long)&pkt.pkt, VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (ret)
+		return ret;
+
+	ret =3D wait_for_response(hbus->hdev, &comp_pkt.host_event);
+	if (ret)
+		return ret;
+
+	if (comp_pkt.completion_status !=3D 0) {
+		dev_err(&hbus->hdev->device,
+			"Write Config Block failed: 0x%x\n",
+			comp_pkt.completion_status);
+		return -EIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(hv_write_config_block);
+
+/**
+ * hv_register_block_invalidate() - Invoked when a config block invalidati=
on
+ * arrives from the back-end driver.
+ * @pdev:		The PCI driver's representation for this device.
+ * @context:		Identifies the device.
+ * @block_invalidate:	Identifies all of the blocks being invalidated.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int hv_register_block_invalidate(struct pci_dev *pdev, void *context,
+				 void (*block_invalidate)(void *context,
+							  u64 block_mask))
+{
+	struct hv_pcibus_device *hbus =3D
+		container_of(pdev->bus->sysdata, struct hv_pcibus_device,
+			     sysdata);
+	struct hv_pci_dev *hpdev;
+
+	hpdev =3D get_pcichild_wslot(hbus, devfn_to_wslot(pdev->devfn));
+	if (!hpdev)
+		return -ENODEV;
+
+	hpdev->block_invalidate =3D block_invalidate;
+	hpdev->invalidate_context =3D context;
+
+	put_pcichild(hpdev);
+	return 0;
+
+}
+EXPORT_SYMBOL(hv_register_block_invalidate);
+
 /* Interrupt management hooks */
 static void hv_int_desc_free(struct hv_pci_dev *hpdev,
 			     struct tran_int_desc *int_desc)
@@ -1968,6 +2254,7 @@ static void hv_pci_onchannelcallback(void *context)
 	struct pci_response *response;
 	struct pci_incoming_message *new_message;
 	struct pci_bus_relations *bus_rel;
+	struct pci_dev_inval_block *inval;
 	struct pci_dev_incoming *dev_message;
 	struct hv_pci_dev *hpdev;
=20
@@ -2045,6 +2332,21 @@ static void hv_pci_onchannelcallback(void *context)
 				}
 				break;
=20
+			case PCI_INVALIDATE_BLOCK:
+
+				inval =3D (struct pci_dev_inval_block *)buffer;
+				hpdev =3D get_pcichild_wslot(hbus,
+							   inval->wslot.slot);
+				if (hpdev) {
+					if (hpdev->block_invalidate) {
+						hpdev->block_invalidate(
+						    hpdev->invalidate_context,
+						    inval->block_mask);
+					}
+					put_pcichild(hpdev);
+				}
+				break;
+
 			default:
 				dev_warn(&hbus->hdev->device,
 					"Unimplemented protocol message %x\n",
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 6256cc3..9d37f8c 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1578,4 +1578,19 @@ struct vmpacket_descriptor *
 	for (pkt =3D hv_pkt_iter_first(channel); pkt; \
 	    pkt =3D hv_pkt_iter_next(channel, pkt))
=20
+/*
+ * Functions for passing data between SR-IOV PF and VF drivers.  The VF dr=
iver
+ * sends requests to read and write blocks. Each block must be 128 bytes o=
r
+ * smaller. Optionally, the VF driver can register a callback function whi=
ch
+ * will be invoked when the host says that one or more of the first 64 blo=
ck
+ * IDs is "invalid" which means that the VF driver should reread them.
+ */
+#define HV_CONFIG_BLOCK_SIZE_MAX 128
+int hv_read_config_block(struct pci_dev *dev, void *buf, unsigned int buf_=
len,
+			 unsigned int block_id, unsigned int *bytes_returned);
+int hv_write_config_block(struct pci_dev *dev, void *buf, unsigned int len=
,
+			  unsigned int block_id);
+int hv_register_block_invalidate(struct pci_dev *dev, void *context,
+				 void (*block_invalidate)(void *context,
+							  u64 block_mask));
 #endif /* _HYPERV_H */
--=20
1.8.3.1

