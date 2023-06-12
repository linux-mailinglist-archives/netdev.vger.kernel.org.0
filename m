Return-Path: <netdev+bounces-10071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EB872BD13
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 134F0281174
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEB918B1C;
	Mon, 12 Jun 2023 09:50:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FAB8828
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:50:36 +0000 (UTC)
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07477289;
	Mon, 12 Jun 2023 02:50:34 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
	by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35C85FUu007632;
	Mon, 12 Jun 2023 02:50:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=Iz0q2NMc2CZeTAf7YBovo+z/ygBGZ6AxQ+GXdVT08b8=;
 b=WZ9V5AoUYXAu9p1dlWG6SXfJlp6Hi+OooukaZ4m9W2nxcfqelTQbQRsp40yG3vS0gxGc
 t/jMI+twZYYob91HrUvoD8RK0HfjLjt194q2GJF9gg7qf1gMPnBGugvr1Bugz9gMXu1E
 77PlqPbR7n3fh4fet8tnX7ynSN1h/PXUmkbnoauYePilV7c7uX0Fyzitq+Khts54Mz21
 Txjs4zyssB20WZLkXo/U7B3ptGniAOyXWuLyVyGOJFCwhBbF9gwmooS81RB/PzeZ80p4
 LRDRl110jA+/mDE4gahb+FgZbwoM3hts0Tmwe3mIJKLnNPlOX4ewsdJXAh32S+WXrqwi Yw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
	by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3r4r3tp1xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jun 2023 02:50:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1686563404; bh=enhvu1QtyM0Hnm3lA1ZuZiAy8pzdGbqJ85XmYnm4f6o=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=Gzg6/nPqU45hnb5UQDNsv+DbzDvc+WlAFF78dUq36WP1VLF1vxBk1tpqDB7XmlnZK
	 jFNwEmZjW++zxu85DKJbSy2Elw+XZypFJ4uYw9aTTdz9Kzrikp4uoKguD8PRV+v0IN
	 qMJLHwgh21AlXOj8Q8woAMz8U3/+LGp4O7UbSjSQ6wXVQvS48u0OZPnSa6Aj24srSk
	 buP6UIP1+FcQ6R/uoPuY2vfPwlBx0OHXcjDv6lPUbR7stUNI7TOop9GP0/aqjzECZr
	 7+cR+OXvtEXvzVMG8RrkDkOlXRZ3SmGkb1ptjYRr5Kc+0QE6r27k58vb7JCKKxCpiK
	 KZoEJoRW1Swlw==
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E940A401D2;
	Mon, 12 Jun 2023 09:50:02 +0000 (UTC)
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
	by mailhost.synopsys.com (Postfix) with ESMTPS id 6CC00A0062;
	Mon, 12 Jun 2023 09:49:59 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=gEmLrYXu;
	dkim-atps=neutral
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id 046804013F;
	Mon, 12 Jun 2023 09:49:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2UDz/aII7EEeOVIfZPc/WHtvh/GDAExuubFAgN+GXhmMO9VRw9BhpsH0Y5NO6O9RXBTyRrBx9uQFYEaNEJtMTAffHCd+iDX830/rVib3oy/rRGfjMdkFaQP6HAEicN74Vc8WxAFkiqGUVYSIFN4Tv7j8+5ccnkcn3F7ICJnucKwY5tvdIg6wYTvSIiY0S0vBe8WLIWp/r6d6odQ/ZqE94mFKnX7XGGiouk7m9aN06QMGRPZvPwwab9RjHKkRgBU/6c5tMSwKBC0AolCbN3X4DfNtBhUfmxjvymjLj3kSH7laPg5e4CcrHTAzhe5sOOCwarqG2QaZoSje5W7wqcnvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iz0q2NMc2CZeTAf7YBovo+z/ygBGZ6AxQ+GXdVT08b8=;
 b=QhQMlvjpBMfHAGIcAbgRHlpYXj8XX6OmTMyf9bCFmp5v2fMT08cF3ngQdq1onxbcYXVx4ddQZJNwpMriT/hLiwcJ4R5hPSCGQzojOGjI1lncxKeQJvzkO7vFjUPqOR6kDl1ATU0KTPow2P6L+1fPgkXCo9Qw5bKn3rI4uekUslEx2O0rllXi0Row4pmLVTWA0Jzl8KM3qhQW7ysrQAUktP3BY1aqQ43/F7FRqcUhHoZkCVUjVqYeW2764cQzwj2QWZ4sE3T6zHrVX2jRYJloq2TOpUqdDTb0Kd0nRQ66tLO8D6CsihCKXB9VF6wtJxjQsMrckAMgdX+13lzBhezz8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iz0q2NMc2CZeTAf7YBovo+z/ygBGZ6AxQ+GXdVT08b8=;
 b=gEmLrYXu90iGwP4s70q2g4inECvs1xnf7DETHNebEmyCu3xJ/YBk9CfLCUY+gcqf7+qipFS5FCVOKqLlg87kR+mb0Qs5tT7B0w1EfOLVdU9kPrtPxnFWQ/WSr42XSFR/3lJ7SqUcjKaOFc6qtjo3FWV+/WBf/ZgtseEPGIoPo9w=
Received: from DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) by
 MW3PR12MB4555.namprd12.prod.outlook.com (2603:10b6:303:59::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Mon, 12 Jun 2023 09:49:53 +0000
Received: from DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de]) by DM4PR12MB5088.namprd12.prod.outlook.com
 ([fe80::2f21:4162:3ecb:68de%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 09:49:53 +0000
X-SNPS-Relay: synopsys.com
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio
	<konrad.dybcio@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Giuseppe Cavallaro
	<peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: RE: [PATCH 18/26] net: stmmac: add new switch to struct
 plat_stmmacenet_data
Thread-Topic: [PATCH 18/26] net: stmmac: add new switch to struct
 plat_stmmacenet_data
Thread-Index: AQHZnQ/BBc6sAV7fFEaRb6UdKc9kka+G6riQ
Date: Mon, 12 Jun 2023 09:49:53 +0000
Message-ID: 
 <DM4PR12MB50885860C71F9E908A920CD0D354A@DM4PR12MB5088.namprd12.prod.outlook.com>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-19-brgl@bgdev.pl>
In-Reply-To: <20230612092355.87937-19-brgl@bgdev.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcam9hYnJldVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTc5NTg5ZTVhLTA5MDYtMTFlZS04NjJhLTNjMjE5?=
 =?us-ascii?Q?Y2RkNzFiNFxhbWUtdGVzdFw3OTU4OWU1Yi0wOTA2LTExZWUtODYyYS0zYzIx?=
 =?us-ascii?Q?OWNkZDcxYjRib2R5LnR4dCIgc3o9IjE4MzMiIHQ9IjEzMzMxMDM2OTkxNjQy?=
 =?us-ascii?Q?OTIzNyIgaD0ieXdEdklIb2pYZlB3S1dKWW02L0liUW9nUVlrPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFD?=
 =?us-ascii?Q?MW83NDdFNTNaQWJ2ZmZPZFRtb3EzdTk5ODUxT2FpcmNOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUFGVmFXcEFBQUFBQUFBQUFBQUFBQUFKNEFBQUJtQUdrQWJn?=
 =?us-ascii?Q?QmhBRzRBWXdCbEFGOEFjQUJzQUdFQWJnQnVBR2tBYmdCbkFGOEFkd0JoQUhR?=
 =?us-ascii?Q?QVpRQnlBRzBBWVFCeUFHc0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtBWHdC?=
 =?us-ascii?Q?d0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCbkFHWUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWmdCdkFIVUFiZ0JrQUhJQWVRQmZBSEFBWVFCeUFIUUFiZ0Js?=
 =?us-ascii?Q?QUhJQWN3QmZBSE1BWVFCdEFITUFkUUJ1QUdjQVh3QmpBRzhBYmdCbUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQm1BRzhB?=
 =?us-ascii?Q?ZFFCdUFHUUFjZ0I1QUY4QWNBQmhBSElBZEFCdUFHVUFjZ0J6QUY4QWN3QnRB?=
 =?us-ascii?Q?R2tBWXdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZ?=
 =?us-ascii?Q?QWJ3QjFBRzRBWkFCeUFIa0FYd0J3QUdFQWNnQjBBRzRBWlFCeUFITUFYd0J6?=
 =?us-ascii?Q?QUhRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElB?=
 =?us-ascii?Q?ZVFCZkFIQUFZUUJ5QUhRQWJnQmxBSElBY3dCZkFIUUFjd0J0QUdNQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCbUFHOEFkUUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFk?=
 =?us-ascii?Q?QUJ1QUdVQWNnQnpBRjhBZFFCdEFHTUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R2NBZEFCekFGOEFjQUJ5QUc4QVpBQjFBR01BZEFCZkFIUUFjZ0JoQUdrQWJn?=
 =?us-ascii?Q?QnBBRzRBWndBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWN3QmhBR3dBWlFCekFG?=
 =?us-ascii?Q?OEFZUUJqQUdNQWJ3QjFBRzRBZEFCZkFIQUFiQUJoQUc0QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ6QUdFQWJBQmxB?=
 =?us-ascii?Q?SE1BWHdCeEFIVUFid0IwQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFITUFiZ0J3QUhNQVh3QnNBR2tBWXdCbEFH?=
 =?us-ascii?Q?NEFjd0JsQUY4QWRBQmxBSElBYlFCZkFERUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBY3dCdUFIQUFjd0JmQUd3QWFRQmpBR1VBYmdCekFHVUFYd0IwQUdV?=
 =?us-ascii?Q?QWNnQnRBRjhBY3dCMEFIVUFaQUJsQUc0QWRBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQjJBR2NBWHdC?=
 =?us-ascii?Q?ckFHVUFlUUIzQUc4QWNnQmtBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5088:EE_|MW3PR12MB4555:EE_
x-ms-office365-filtering-correlation-id: 3b666670-8c4f-4dda-9be4-08db6b2a5f3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 QlxpJUudcA5DdeWa+HPjuUvPocg/8mzqv7/CC5v6Pt7KX4UzgEYJlLN4i/1qLWEPspHfXGRzJ/In+30ZnP+A6yNFSblXZHok9DjWw4o05UGxE1iyanpUTieuQ5BajXpIdGIYtYdNuaVCiQraIEMshZ1BXEF8s4HPeE7MoljtXcodqi4I1w4WWA00rNyzPzdMH41HnssmRqEkSn1JU6FCoCSpmh5/BFQlnmAvZ2A/04ZWfRYZHPgWqXsP7ltma9ml3JSSc5fAh2l3iMfV6qTD8y7WoO/YdATpV6grd3cLIn2xhrn2C54sVmjkV8BJkHilSnMH8+AA7DDFCVDtxy3aXe4bJRh7hmgnL3Mkmt9zNBCIYleqOj9NpTjraNV0FQGaR6YgOfbVC5qFM5MUQRW9uWkBuObpxJrkZbJL9jvJo/ydpmzgj1lAxL1aPVrL1Dui3fJMruRrf0DbfPHt6QNtnV03mmtrvZQmJJLn0+8LxC3nZVAlER+d24KYsRlpUpR5z2A7+Y3Kr9xweJnaKciFJwNUvenyy3O4ygf0rFzTvfQAf0FlYqGjUbHz1PeyHTxeqvPLs442Icwwop/7/vJYS3oPvT+Ie62/uKzl10oOEhGd5szcZZrX//VHat7xZieKXLkWTD1Eiu+HD/z2WG8Sxw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5088.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(86362001)(107886003)(7416002)(7696005)(316002)(8676002)(41300700001)(83380400001)(5660300002)(26005)(55016003)(38100700002)(9686003)(122000001)(6506007)(52536014)(921005)(33656002)(71200400001)(8936002)(38070700005)(66446008)(66476007)(66556008)(64756008)(4326008)(76116006)(66946007)(478600001)(186003)(2906002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Tuy64uS5BXdifAjhD/1dTr4jTYtRY+yF1BR07rkCJg5Q7c08Q+fEHz/yJhpO?=
 =?us-ascii?Q?FyZfysoTKkHOskcq4exiwNkClTrP9w3bMCX+dLkh241kh5kqBzupf10409aX?=
 =?us-ascii?Q?3kIjRjy2Njb2S3dri5ZGz6joeFoYKCcjuQmlxLKLxw9JVGkxWxIZiwPjIqB7?=
 =?us-ascii?Q?gWXHQiUr5yggfJgAXG1wq9Dm8sjA+srPaGRv40F1fJO4uJEx8KcE7efkujdZ?=
 =?us-ascii?Q?L73ipn1A5V+TTUD9cGvFIPQE0PbFYk8x50uGkgt1PHw8QxCeSeuR+ks3TIzJ?=
 =?us-ascii?Q?Jqhkb8z9f5fIzYdlMt6c7sTxZMixwI7c4T73FnZJVsAyp9AcZ5QLGJhgFxnJ?=
 =?us-ascii?Q?1IKErOarchvk5jvKLfbLNAi1OziviRhxK9WeUNKGdRZ3Vg9z+OC/UJnMpDu4?=
 =?us-ascii?Q?H0rZP+3iGfmY6DH+auCj8l1vfMl9rRUj8KaAnWuZPhd2qVVudKQGaC33gwNG?=
 =?us-ascii?Q?7cGtsvBOUrjMqX/Eh9tu1739HJKGIRkVAtanaWHRp45ncGCQJaR7bm+iXVJy?=
 =?us-ascii?Q?oU8uLdoqXK1BYjTiULhuTal5mGorjoa6SDJy9gw2iVo+IUwmo3J3jrB4DHbz?=
 =?us-ascii?Q?HufKNiQPyZhPx5Ex9LDJligkDNtqvndGwfIH+hwZZcZTh8O6O7GSrfd+zKTe?=
 =?us-ascii?Q?H6i9c+rXkuxtHn/zptsWnnJeM4SOY/u0DxK6Gbt6La1cvdg0mRqHwUkWYueB?=
 =?us-ascii?Q?cPyiDITTk6RNvZMPtrPTz4P00mImUMaL0H9zEfVXeGZv0zOowowvrYmG1ljJ?=
 =?us-ascii?Q?6dvYcqI5tCmlzjAhRo9S0r6MXrxL+nPxPpzav3n4gcLCkQSTcTUlsxK9TVMs?=
 =?us-ascii?Q?Sunepl8tBCCITPifBWxM0+1L8dmlnkR9hYcrLyETARblxqoEpMB8cyGCA9qD?=
 =?us-ascii?Q?+yPHbJ5WtM5sNyAF6H+0xmjGP1WRinOILwDdOzj1q2e07VjLzuPjRuKpxTZg?=
 =?us-ascii?Q?Iehw2vsuQr8ES3KqLkEWi19RxL72/Mx0vSM3AoGUIxaA/asQwCN7m6yiiWax?=
 =?us-ascii?Q?G98zoNaAjxARqOHH8GOCS50IBJ1O7a0YZwykQB4BCMeiEvFQTNIoszAixhl4?=
 =?us-ascii?Q?j9fVHbDV8dbeN77u83aJVIMyWQIFAOCN76qxdBJ6yT8sKp6m2dRUb1mI+VzM?=
 =?us-ascii?Q?FCClXC5QbPdguxbhwxbAL6KPToLSWkbLJvnd6AlijXhsi3duZ8Tr3PkWQxy/?=
 =?us-ascii?Q?kTPeBFJd6UI/NuBTVF3n7Uia3SaU6eUDlPkavItbD5jqBfO/ZLdjcVxbW3sJ?=
 =?us-ascii?Q?7NK8HLsrg5MUheJWY6R1463gHwELtlbHgK67SvRJv5MmVmaaXMUGv3L0ilNf?=
 =?us-ascii?Q?pQet2jidCppx+6MZw5Pfnl2wIPwZBhmXZdWjS/WItgCwYh3BCibOqVVVnGhO?=
 =?us-ascii?Q?WQQWuzQtz4iuEP76fCdoA6dEbZDheJcrwhpJMn4SW3oN5xWquBy8O9aU+KVI?=
 =?us-ascii?Q?6lMK5wORu+blGRSISeZLkobn8yjrP+eZu/oS/paVanFnb2MlgIpp0Q5DCb/Q?=
 =?us-ascii?Q?M0j32F6H3qSm43W5HVrtJKwb42nxhLBVowUGD+PmgHubjkvsa0T83sdc0D2P?=
 =?us-ascii?Q?5R99t0AT3tW3IkiqbP6WIqmuJPk6hD8u1XaXeaxt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?qW6Ch6SI0Kgy2pMg2aUn6aQBRQMo14TMIEIVoeojc3UBdtayVM32+zgJ4k8q?=
 =?us-ascii?Q?PDACWhoiuR/mvXZNSxgo9GGpbuoKVqJDNMtkwB9K+iTJkxUtgf/nzUwFSM20?=
 =?us-ascii?Q?IXa+sJsp519vMvZsptXvwGdtO0wbrpcg9hQwEErXGH0EuRBPVie8s2+xEQgy?=
 =?us-ascii?Q?ZJBfHP4MVwEHCOFjxg9QzBXWEJDx8HB/FN/MEUymAih7p2HCtZsjILToAiHT?=
 =?us-ascii?Q?FL/3XoMf8f+4JaNjfThLpC9dSKoLNq8RM5JzLZfoVcfWdVaCJStwl5bv4icw?=
 =?us-ascii?Q?9wW945+Vcp+s8Ld6FfCxdMqcmfZNDUP9H4dpq3GAiAfOFnx0WojDoDM5UK7g?=
 =?us-ascii?Q?z3TBVaUvhk44aHt+XgEKbCWGE6m4X7pykufEP0M6uSpfDC2afBNkhOjkFl0P?=
 =?us-ascii?Q?XPqJd8KXRDBI4HTt3MQjBJSc8v8r1yzmLQDAQCypPUF+I0RxpN0+TWgfm29O?=
 =?us-ascii?Q?zAp/YgH0uDoikbJxWbE3X1Qyv4vaRhEU5fDFI+DswVVWN0Qu/88x8Mah5ziQ?=
 =?us-ascii?Q?7/qKXKq+PfUGr0vhbxYfkZlBCIWn1B8vz9MfKAuZ0xFL/hpRbQ2xCtv0ApQ+?=
 =?us-ascii?Q?SZOwlBLOCd+bBvYc92MU27dgheXnynogFnhel6d9SWv7JgyKS21FuHiunlS4?=
 =?us-ascii?Q?KJiOhUz6u+fTHHvuvfvXcnEWKKYddoSb5Yeotm8PsOMww30jYIOdul2jCsGD?=
 =?us-ascii?Q?skBBnxDBARKFd+HGtBnNzjQ2vW+lhU5XGdJOGA7J8SG9j4A3KbcwymXuCnjO?=
 =?us-ascii?Q?IcOCnwdOWSQoeWi/TQqX/ZfBnKSZo2IsCEFixnqy3by6sVLG5AqvTGjyY9/z?=
 =?us-ascii?Q?T5kaw0jyQa2beuXDQP0Wf0XWmaQQowcwkP4F3ks0MUlbQneIZtPTi3hQlEZr?=
 =?us-ascii?Q?nAI6AroJBvVoX3UKFjmN4VntISDn62WCNHmzfG9h/m0k60qqC/J9XYQVIc9H?=
 =?us-ascii?Q?9hPQlUcFfLXzM+jqCeqjuYM4m92qkxkKesrzc80qaK5sjJiHxEugGZucCJ+a?=
 =?us-ascii?Q?q9Ry3Pz9qHPJnAshGk13+WtPRYAggaEByFkFR/T62T5SInie08Z3GCM8i0YV?=
 =?us-ascii?Q?AnxgV6i6BosKMNwQkiJhIgoafaYj1IhhGpu3jAFXrpxKRkHkfzRrEucuE69O?=
 =?us-ascii?Q?WvXuqkB2vIQI2rMvoCrAFiyuL4pyYKhosFb8k5rDl7uJlviNDlzKMdo=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5088.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b666670-8c4f-4dda-9be4-08db6b2a5f3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 09:49:53.3563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TpFs+OHTmy4OpUk2Tv6Yiavy8Vpzihr+k9qRw22JhX/qPeOhM+NMjZYUx+mE4P2hGLVSr0u4sJ/btOTHYLaPkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4555
X-Proofpoint-GUID: TXdyPQLeuxDYW9psUziloD-sBv42-6SN
X-Proofpoint-ORIG-GUID: TXdyPQLeuxDYW9psUziloD-sBv42-6SN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_06,2023-06-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 phishscore=0
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1011 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306120084
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, Jun 12, 2023 at 10:23:47

> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>=20
> On some platforms, the PCS can be integrated in the MAC so the driver
> will not see any PCS link activity. Add a switch that allows the platform
> drivers to let the core code know.
>=20
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  include/linux/stmmac.h                            | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index fa07b0d50b46..fdcf1684487c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5793,7 +5793,7 @@ static void stmmac_common_interrupt(struct stmmac_p=
riv *priv)
>  		}
> =20
>  		/* PCS link status */
> -		if (priv->hw->pcs) {
> +		if (priv->hw->pcs && !priv->plat->has_integrated_pcs) {
>  			if (priv->xstats.pcs_link)
>  				netif_carrier_on(priv->dev);
>  			else
> diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
> index 225751a8fd8e..06090538fe2d 100644
> --- a/include/linux/stmmac.h
> +++ b/include/linux/stmmac.h
> @@ -293,5 +293,6 @@ struct plat_stmmacenet_data {
>  	bool sph_disable;
>  	bool serdes_up_after_phy_linkup;
>  	const struct dwmac4_addrs *dwmac4_addrs;
> +	bool has_integrated_pcs;
>  };
>  #endif
> --=20
> 2.39.2

We should eventually consider changing some elements of this struct to a bi=
t-field.

Reviewed-by: Jose Abreu <Jose.Abreu@synopsys.com>

Thanks,
Jose

