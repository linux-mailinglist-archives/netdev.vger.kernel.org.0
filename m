Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3034A3AB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCZJHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:07:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:18822 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhCZJHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 05:07:03 -0400
IronPort-SDR: MZlIj5y/EY6hD257tDzUDn6s6SgNgbXr5PtM3vOrwuE9QQjDh4c/s8cmHshnxvTVhNSSxlhaMO
 thZ4TMBqZqpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191206940"
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="191206940"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 02:07:02 -0700
IronPort-SDR: A/ZL9i2cr2PM7enh9KXokpfp1fv6Zy4iZgRLZDit4ZVlyNH2CY9brkQk4Dbmxkwv9G4og/Yt8i
 Q6aqxxx/Voiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="443749721"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Mar 2021 02:07:02 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 26 Mar 2021 02:07:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 26 Mar 2021 02:07:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 26 Mar 2021 02:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYxqcrCQir1uXWJ27XijYMcqZ7RRXNMC4Vj7fsL4W0tNQGyYoKhZ1jSbGhss2d4ZBmTgHN/0k/TF1j103vrlIKFZFQG55dNOjR6V2IVY80ZoA0tvGPUzJSlu+nX+C5IByGfBO+JIaHOCJnWk5kz5MzejPukKUzmSmN0fi+MNHe+NOy0pWVz4f0N1iAz8mXpwrO0qHjmg4avm3aNzbQvmhFaQ1RfLbuAQz5nw4pDGcSFZTVirI23jXg7D18AA0rQKgqupEN+UAZgSygiS0llK2NcRx/FQCjWJ+5Z+LFimDNVF1MqjqCFmklShkG+mOBqmcubCuG/3uGnq27oP83mtYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYaIt9lI+7jx5gzT45CIi3ifOdSMyvZci5POJaFxuTc=;
 b=OG7EEu3cw4AMS23HADkJyBdzUyV7F/N8i3XEeQggx5xieyGgYL3fRTOfmT8hpNMjydjyRRNDIysp4CxPWjxtPEFlOYOtZ/7nEzciYaISW22KcviSEeXC5r650AzYmAL4waqNY2F2K2+2vEt7KccDJS0Hajzqg1V2Q1F3Wm3WYGxFQqdOUV8lLT0oG5LFCmOeOYYWyHPFgf86q5t/LRD4lWsR+i+r8ZYmN6uziLcLEY1yHmk3IEonDPcZSZPY3/epaFCeLRESLc9kb/S8GA5r95p1atq9qlaKLYnq9Cb+Zd994Lyip41vK8X0akt0ImKhY0mRt4KJexVRGKBxcFV4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYaIt9lI+7jx5gzT45CIi3ifOdSMyvZci5POJaFxuTc=;
 b=rAHD5T04ZH9WQ5z1u6Jfjt81Ar4MEyq+ZrdrXmaPSdRduD0kFI4srG93fDFC4Pafo/fI79LxwEr3omyhbj8Mr2HfqdT9hVmbkRwcsJx+54JS/8GDvO6dPv3QLmuW5DYxa7jgegYD79nibHyMOoCX9sJatikyv2Aq05Y8+G0aEFE=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Fri, 26 Mar 2021 09:07:01 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.3977.025; Fri, 26 Mar 2021
 09:07:00 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [PATCH v2 net-next 4/5] stmmac: intel: add support for
 multi-vector msi and msi-x
Thread-Topic: [PATCH v2 net-next 4/5] stmmac: intel: add support for
 multi-vector msi and msi-x
Thread-Index: AQHXIZ3TBtekzGWN+UCr/4XQcRVy06qV+kjg
Date:   Fri, 26 Mar 2021 09:07:00 +0000
Message-ID: <DM6PR11MB278048DC1A5138C9CE79F6E7CA619@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210325173916.13203-1-weifeng.voon@intel.com>
 <20210325173916.13203-5-weifeng.voon@intel.com>
In-Reply-To: <20210325173916.13203-5-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.169.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99e660ee-5098-402e-c65b-08d8f0368429
x-ms-traffictypediagnostic: DM6PR11MB2650:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB26500F0D2C5F28F682D85747CA619@DM6PR11MB2650.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WdmUUHJo5iJrFgHxokC5DwXdfKCnVX6tH8Ys0dYFvBj0JyYqZzH6XzMoFwMt/7sGC+dqAU7nIZ60jWJ2yzqnKuWq7/p3kf4XGRkoUxRfmBjChQp+U2fwjGLpfGUBtnTbS2kqmR50QiUSn61TK2HnBm0xM5D1C8uz1387fylFwjIKIYsNPegIEq67FZ17/RLiG+aLSpVLzmNRxAguZJNk3QTyqQeESc9X3nIkGmRXBww/KMBieCEgONXGQjnyjTRRb9TwZO3znKNQMOx/piPLlvRBxgOvxPHNRW8gJznKbe71u6Zdg4sQetb8Boq4pdlESXkEdHtjhVlDtDv7HYCQNkpdE25Ds9CG7numy0jqqpL23eco5p8hStdsxZF5Qm9CmvABlUrtcjkPfQoGD9fWb4ztHg7JaFuF8ZtVhcZuQmbAX0cau7mJNwzcO7dcu6TAW1eoychjRP+vi0/wMpOZvZ6Po/Vs/czhgLIeN4pkjPUWP3kyGDIx3nQOu9wwmyENUaD9xcjf6dQX0Oq34Xfvtm2bFWm2vbIXwTBsx1cQfQaP26XTRnJvyKN548NnsnkOhzFfPesT7MtwysLDfwnqzMSn/r5ne9nMyZoUESj9yF1W88jPYMlcLt78/HdqU4oSFdzJwUlg5RiCSDMU0gVo3/d290eA7mwOepQo6hEFqSY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(366004)(39860400002)(136003)(76116006)(55016002)(71200400001)(9686003)(8676002)(33656002)(2906002)(83380400001)(54906003)(110136005)(316002)(7416002)(6506007)(52536014)(66946007)(107886003)(8936002)(186003)(4326008)(66476007)(478600001)(64756008)(5660300002)(86362001)(38100700001)(66446008)(7696005)(66556008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7J+IVdMmwLCG1/F/5hcrilyPrR7L1U6BIlbu5J1fAowqzo7g3p8Aht7Q/upb?=
 =?us-ascii?Q?ttQ1nplvIs9VkEbNXI3/vNd+RUTe2HGw6QV3rYb50o/IA8uBBzYD+cKiQ20J?=
 =?us-ascii?Q?VkZFf1IHpgXGnhnbUlvHLUhRTwtRLBXRWj7ewVDMDtcpKOjUrLgyyHbNsme4?=
 =?us-ascii?Q?43Bv98qAZyil2DeqQp4BU1goVluAjP1atCjpUKcsZZWJ9Q5cFNhQFLZvac7/?=
 =?us-ascii?Q?V7dWo1aRNzFbfb/KZBH0MbLHsrHZWeglgvYVJZwXkdMGV7xWY/etsCV3BR6R?=
 =?us-ascii?Q?QvOTX5ZdE0piSjkEob0KDsbTcOeYe9GpxRi05eqspcWK287U1TrIpDUicl1B?=
 =?us-ascii?Q?ER57g/zqc9mq2r6vkn0N9qm+zEwEOiDz7rpJGeloYnG4MADhsDw+4NAVqI6y?=
 =?us-ascii?Q?ULno1j+iAuB+bif5p1fWHqaTFP3aYdrE8E2Qvn3Dp54JWA62Lh//o0Dc5rA8?=
 =?us-ascii?Q?43EWVed94jQ07ek06aUyURc4oEUM3crwIs2gYCoBql7+v1mS07sZIFt3/BAO?=
 =?us-ascii?Q?iH5gP0yGuvbpFlTf69ji4lghMPTPcUds7kLdvbS36F3dOl0fnKl8Bjfqx/Os?=
 =?us-ascii?Q?4lpw9/zGwGm0UDi4l8UejIBCBZJlUpzNk9zHp+78wfy+GyO76Ex8oGmcE1ys?=
 =?us-ascii?Q?jTUr1Qt3NRa2MqqOTP+o19HNhz/Q15P3d2hcfq0KOTcRbdD9eod11rpSz2A7?=
 =?us-ascii?Q?dBx+2bzbeMSrPbJ8g93IA5y+vhcOdb14S0S0MX9gSxU4wAkvyfNNv3Td0CdL?=
 =?us-ascii?Q?8zf8UAO7uqz9T6GSmagzUxVCttcL0gEcAmnhnFWp1zsJQ3DQvPkzId2WrPus?=
 =?us-ascii?Q?7WfYYJEXT4cpRK5OapOvSDtHbmROBBFWAddEjexqrRd3k5TnZs/FV3Zgy6ez?=
 =?us-ascii?Q?6kl4S2XeR1+T1ZmVDpx9WqZF4GQLDvKa25qyWa6qq3kJ5izTMZVmbPWsLnnS?=
 =?us-ascii?Q?O2tM3HCKo84vLGJQ1ZaaZK0NqVuJ7M2R15R2q2XBjFzqR5Mhmk9hTaoT5aMx?=
 =?us-ascii?Q?7Sx2yHss9Q2gK66SJsZQbRftuO1uhN2U7ono917PKkM4rswRMcup0Joz9doY?=
 =?us-ascii?Q?3tOYgo4aAw4lkmhwbxFcP9VF7o8FMJJiDCb1hBG6yxFzoUHZtrXVKJ5OegpO?=
 =?us-ascii?Q?i4bxTnK0qbcIFrHUv9EJS6e3kdryg86YKM0oN/NWmkKQC3ZAPN3wSMJ/fNCU?=
 =?us-ascii?Q?yWliyb1HRNURwQOB41ef7tmra6yql5V6RSrHoVDBI6pRFEQiBsdn+I3zkEfy?=
 =?us-ascii?Q?njDO/eLnwevKA9i309lW5S+wG8g1aF38sFMppYgy2KZ7B2994Tmejn+EbP+m?=
 =?us-ascii?Q?7aG3/SQu/CC5o20+IjZ61Il8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e660ee-5098-402e-c65b-08d8f0368429
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 09:07:00.8076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tM7oQ9j68ETMTODs1xtTTgBzWQ1JhwVD4c1rmgyRtWHPI11jBxtDL2XgKrMewbo7dHJvKMyiEeOvG9v/GBpoESxjj6ApGtZQPk6GWmRh4X0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2650
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>+static int stmmac_config_multi_msi(struct pci_dev *pdev,
>+				   struct plat_stmmacenet_data *plat,
>+				   struct stmmac_resources *res)
>+{
For optimum RX & TX queue processing on the same IRQ, we should use
irq_set_affinity_hint() to set those RXQ and TXQ IRQ to the same CPU.
This will benefit processing for up-coming XDP TX and XDP TX ZC processing.

cpumask_t cpu_mask;

>+	int ret;
>+	int i;
>+
>+	if (plat->msi_rx_base_vec >=3D STMMAC_MSI_VEC_MAX ||
>+	    plat->msi_tx_base_vec >=3D STMMAC_MSI_VEC_MAX) {
>+		dev_info(&pdev->dev, "%s: Invalid RX & TX vector defined\n",
>+			 __func__);
>+		return -1;
>+	}
>+
>+	ret =3D pci_alloc_irq_vectors(pdev, 2, STMMAC_MSI_VEC_MAX,
>+				    PCI_IRQ_MSI | PCI_IRQ_MSIX);
>+	if (ret < 0) {
>+		dev_info(&pdev->dev, "%s: multi MSI enablement failed\n",
>+			 __func__);
>+		return ret;
>+	}
>+
>+	/* For RX MSI */
>+	for (i =3D 0; i < plat->rx_queues_to_use; i++) {
>+		res->rx_irq[i] =3D pci_irq_vector(pdev,
>+						plat->msi_rx_base_vec + i * 2);

		cpumask_clear(&cpu_mask);
		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
		irq_set_affinity_hint(res->rx_irq[i], &cpu_mask);

>+	}
>+
>+	/* For TX MSI */
>+	for (i =3D 0; i < plat->tx_queues_to_use; i++) {
>+		res->tx_irq[i] =3D pci_irq_vector(pdev,
>+						plat->msi_tx_base_vec + i * 2);

		cpumask_clear(&cpu_mask);
		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
		irq_set_affinity_hint(res->tx_irq[i], &cpu_mask);

>+	}
>+
>+	if (plat->msi_mac_vec < STMMAC_MSI_VEC_MAX)
>+		res->irq =3D pci_irq_vector(pdev, plat->msi_mac_vec);
>+	if (plat->msi_wol_vec < STMMAC_MSI_VEC_MAX)
>+		res->wol_irq =3D pci_irq_vector(pdev, plat->msi_wol_vec);
>+	if (plat->msi_lpi_vec < STMMAC_MSI_VEC_MAX)
>+		res->lpi_irq =3D pci_irq_vector(pdev, plat->msi_lpi_vec);
>+	if (plat->msi_sfty_ce_vec < STMMAC_MSI_VEC_MAX)
>+		res->sfty_ce_irq =3D pci_irq_vector(pdev, plat-
>>msi_sfty_ce_vec);
>+	if (plat->msi_sfty_ue_vec < STMMAC_MSI_VEC_MAX)
>+		res->sfty_ue_irq =3D pci_irq_vector(pdev, plat-
>>msi_sfty_ue_vec);
>+
>+	plat->multi_msi_en =3D 1;
>+	dev_info(&pdev->dev, "%s: multi MSI enablement successful\n",
>__func__);
>+
>+	return 0;
>+}


