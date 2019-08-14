Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0008DDB1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfHNTJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:09:00 -0400
Received: from mail-eopbgr800097.outbound.protection.outlook.com ([40.107.80.97]:42124
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728464AbfHNTJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 15:09:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGXeJManhBnjxU8RT29HWQlraNGVEsCnbePl/lfnw414vw1Ct7I5nTFoKsHPbsOWF7VyNjxJFTfh9EztSS/XBNycACKTruGZxm35V8j7B8C+aTOLCVO+pFH9wcIocR6tT2NdkddDMGMW1bJN0xzXR8orD6e7zGWLXinyzAgAKd+/YRboD6TIUcy4JOtiyq19fKUWMIXu61K/jpbHVh7UvegTR3KLNYI/h10/LX65hPr4p3QODycmmAetUbz/A+spfaxjooRrPHlrgSb3ZesoI2koc9BAVCby+1IN5HeqMHoETmsKdSyD9L4peg9F7UXLH0HhrhRtKDMjHvVoqspc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8//GOpJEL/Hp72jQ11NhDe6pU7e08emO3MeJRroTew=;
 b=Ox9fGiLAr7NwsbQDaUkneCCLiGCko68Hb/eqH/uE34YVjjZ6xBt3Hn+ViiTOfvXZb1Cy24fJBatWOuV8jtZNmYahG0qeIR543dLnH/otOE25CxAkKfBIGE19t/Wouw2hBs0E3wxgjDyMpgjUxyBfY5Q8cddX2q/LoHLwlRtaoH65Xpdp/vV8gh3N1F+yVIlXUKCPMED1z7UC9xbRUQvpZYyi+YNz4Yg8vgdZAhun89ck3nKdkq8FQYN4Z3PJHVI6QyPV53pve8fi+Y9BsXnI8q4pGzxCkXLnsiQR8pehBHMlaGrVR6jdVerPs9WMzCa2cNTPkDbIz3MON7UIC1pcVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8//GOpJEL/Hp72jQ11NhDe6pU7e08emO3MeJRroTew=;
 b=lfMGVMbQEKxRQTXR5uEIjv8+pnTHfZ1QV2m9sDudRaGFKfvZ3mS2gFhpvoVvDgbqx3tgmQ9SQ+wF8VWK8Au8BoXbepoNt+5lkzGCTim/FjIdCHwwl+3W6QqRFIgzddKP0G17joNYhnMs+EGhk0O7tAs8PO+56Ei/K2sV2l0pCiI=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1338.namprd21.prod.outlook.com (20.179.53.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.6; Wed, 14 Aug 2019 19:08:52 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 14 Aug 2019
 19:08:52 +0000
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
Subject: [PATCH net-next, 1/6] PCI: hv: Add a paravirtual backchannel in
 software
Thread-Topic: [PATCH net-next, 1/6] PCI: hv: Add a paravirtual backchannel in
 software
Thread-Index: AQHVUtO2P8Dr4xjoHE2DciC5UUWvuQ==
Date:   Wed, 14 Aug 2019 19:08:52 +0000
Message-ID: <1565809632-39138-2-git-send-email-haiyangz@microsoft.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:104:1::33) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74c4d2ba-96fa-4a2a-f2b9-08d720ead87d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1338;
x-ms-traffictypediagnostic: DM6PR21MB1338:|DM6PR21MB1338:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1338779882B86F02113F151CACAD0@DM6PR21MB1338.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(6486002)(110136005)(6392003)(54906003)(4326008)(10090500001)(26005)(14454004)(256004)(107886003)(2906002)(53936002)(6116002)(66066001)(6436002)(3846002)(6512007)(7416002)(66476007)(66446008)(76176011)(66556008)(2201001)(30864003)(64756008)(66946007)(8936002)(22452003)(71200400001)(14444005)(7736002)(71190400001)(50226002)(102836004)(5660300002)(81166006)(4720700003)(446003)(316002)(478600001)(305945005)(7846003)(186003)(99286004)(2501003)(36756003)(81156014)(8676002)(25786009)(476003)(11346002)(52116002)(6506007)(2616005)(486006)(10290500003)(386003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1338;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IvbHvRBXskAuOw2V37PzkzQKutHnPwXSSIPTUC5+7+HJozr2QJj6y0dOMGyC0ryP2EKdqongYSRkFwgmvPK+oMAh7uzqAZL4/uDOhKWBpHIq7C9lfnIQ79DGhHjuKe4AvK8aeLyW4OcxQQzdrntEQsolY3S1jixvXW/OD0Kh3+Vj3JZM2cBcobLMhIv/LpUSG3JMOnMzsWRUndflIv3C+drp1KyFPCV0JxYKv5yuRlHSJtvoVDWG/qsCQcpGGm0UQo7hApgyILiH0oFXOt/HCj0HdCWsQgPmmcjKNV8z2lrQIiI4pP6GgZW1sVjZBuyo5RPFtbToS3qIaOFcb9ueMfz725oHqOFDNRYaA948BQWjIsN1yPMjodQIsWFN9mX9dQZcVvU7UY0knClRcwHe/0fJak9nq/KmUELt0kDGMPs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c4d2ba-96fa-4a2a-f2b9-08d720ead87d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 19:08:52.4252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eon0AJ/RW2wgez3UcSqgvFI/6ES12LmJwwD0avlT2vMaOKlPUIFGJ0ZPu2iu1ldTNLTDx4ggnWQ0jwV0NjAsDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
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

