Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194BC2525A3
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 04:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHZCxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 22:53:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:22350 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHZCw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 22:52:59 -0400
IronPort-SDR: //RcNWEjEo/y6FDtzgY60j5Lr+iHxXZLTzDENAP1ekvAjq2EljZVAZ/jgk89fxvwyBDIPaQD2d
 7K1SthuMdZHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="153650575"
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="153650575"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 19:52:58 -0700
IronPort-SDR: y61/S8M14Z6R4HdW4Vev9d/PNT7H5K745zUkqym9luKkn71PnK+gcaDqZDVUP4QxURVrkZ3VsS
 d3V/z2kSOiUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="339009796"
Received: from orsmsx602-2.jf.intel.com (HELO ORSMSX602.amr.corp.intel.com) ([10.22.229.82])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2020 19:52:57 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Aug 2020 19:52:57 -0700
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Aug 2020 19:52:57 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX154.amr.corp.intel.com (10.22.226.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Aug 2020 19:52:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Aug 2020 19:52:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxifBJa4oeNTN4C3FaHUxlVI8+x3CLsK809CJjLQm18ief/nqaTch2tHDPETEKQ72vZwfGJcsfe1hvoZb3rTCHHnLMo45tVd9i+mh/5mHsfOJaLg1xtBHCsOlBXDtBAnccuG2gh5og8F4Mr/D7UaU9BygBQD4HqIWs8YKkh0KB1hCIIBm1SNkYxAkkZRYSo9ckFT5Z5JMF/tG6CiRIyeMikgmTLlCQRogilZ0vu+4ZPFo3FWB5AKCkL/2mrOpSc7lTi4EDTRfoaZVN4uJuVGtpf1NKNnk4BQU/sB7fNHbb+vRo9PKj3GVfJZShH9XvmTNB6NFYtiGJoO8MEKlPzWDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFJl8fGACqBScS3klY6dAMEW8/hSfXEzcAcORcIqcFo=;
 b=O9b1QMGjUi+sBDw+phdW6niLc+SUajOwQD6hgh7+n8vfvW7eslz2u1N5TgYIGOU8okOdij8CAqwROvWB/BQW0AOm5I49rvzv4L4dL/g7V1aT4AUwbbW1JHnopixW+xDSrZTfl4e423LWF1RWwl+1ha/c8ndeWni5lzhLNnyyesp8mfwGjGGxs6vljZhSD5rR8DyMxj78SQ1X6VaLErPAtJ2CmnHDsZvFTBQVj2oZ0fiWWHDjBtWj35R7CmvtHYkpXrUSROnGs4ZNezuEDQ9yRTI7saZEP+b4k6I9bD1+qSqge3F17qfTrfkqx30K7+9HK9jDOsB3UwD+qwn0Ep7T4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFJl8fGACqBScS3klY6dAMEW8/hSfXEzcAcORcIqcFo=;
 b=zOW7uBEwTBznVe8cjCfn2cw7b1UBkZ0ZnXnXPxPeLPs1GqRsrXo7JNAcaZNlVQOvd+1tETr0NbtCPSVeOXSXGpFE+y54oPVlhVU18oNUJFZByYdHuWEjutpMDlr2+TsfOvMUdabt3zZGg/5ZNuV3nSuUQ5iU0DF5CtUzJuuKpxY=
Received: from DM6PR11MB2554.namprd11.prod.outlook.com (2603:10b6:5:c8::21) by
 DM5PR1101MB2363.namprd11.prod.outlook.com (2603:10b6:3:a7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Wed, 26 Aug 2020 02:52:55 +0000
Received: from DM6PR11MB2554.namprd11.prod.outlook.com
 ([fe80::b5ee:6a1c:925f:61c9]) by DM6PR11MB2554.namprd11.prod.outlook.com
 ([fe80::b5ee:6a1c:925f:61c9%6]) with mapi id 15.20.3305.032; Wed, 26 Aug 2020
 02:52:54 +0000
From:   "Liang, Cunming" <cunming.liang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Wang, Haiyue" <haiyue.wang@intel.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sarangam, Parthasarathy" <parthasarathy.sarangam@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "shm@cumulusnetworks.com" <shm@cumulusnetworks.com>,
        Tom Herbert <tom@herbertland.com>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Parikh, Neerav" <neerav.parikh@intel.com>
Subject: Recall: [net-next 1/5] ice: add the virtchnl handler for AdminQ
 command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWe1P+04EcPr04FkaiITph21kxLg==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Wed, 26 Aug 2020 02:52:54 +0000
Message-ID: <DM6PR11MB2554EBECDC3C7F19461181B8F9540@DM6PR11MB2554.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9937ce9e-426d-4c5d-34bd-08d8496b21c3
x-ms-traffictypediagnostic: DM5PR1101MB2363:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB236314672DAB27DDC86C9D8EF9540@DM5PR1101MB2363.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ADvGxX2tgNvjhBBRgOAb7mHtcbjNSZ5+nHzQObhdHToVTI/qB9drC1irQJG1blyg0oMXtpxa3cOrNVMYid4yXlK5wBR6OdxGkKzFC2eZqyZRstazOBBWC17Qj57WJMu+Q5N3oPPNduWCvHziuRuhKXrtrkHsbcA6DsCqLA3A8B1UXRtRB4PzYCf16sBRARA5cGDAjNi9KO929Nr6nYMhLKqHvUbeK1yHEFlkK9CfGSzV67tbjKFSfbOtAmhAPe4986ZkwMgW0XzL8IaJpGX1/IIZaBZMQh2AKFilOjtUPSPJ5cQCsnyemFGTdQPkuZSk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(86362001)(558084003)(54906003)(71200400001)(7696005)(107886003)(83380400001)(26005)(33656002)(4326008)(52536014)(6506007)(6916009)(76116006)(66946007)(5660300002)(186003)(2906002)(478600001)(66476007)(66556008)(64756008)(66446008)(8936002)(316002)(8676002)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6iMivyNKujyv6sNTLcLxEOCGkSW1aLwjevpuy3GXX/qA5TOERZAHULVx9No4WevvyLGa7NFrGKcZk4wLPgdD+RIY9PX5pPatjITsWpjqeWG9vKIlmuvyc9mGGdwAMhGHRU7zidVFbAEulJ1Vc0U6g9W/5p9dx+Sc5taYHSJj1hmN8bmJsm/rjv/uYYYPVL2FiY7w6J8FuqMpUoiT9J378tbYm9bTFGcMQEoP4ivS0GPc7dNMbMfuOCgJlx21ZDtRnfF/7bu0Y9FLS6EZGr68sM4tsz8q7hCXmMtQj+/fax9hFMenGmF9G4LbvVZp5gkQEXJtKGk4a0pnmNYK0qMasX8ae3T8gTKM/RPe1tpj7Pln7ED17n9q2zVsRQtaA1NDF3Fo0LV1HiyUl2KC3nICanK64eRF526mecM1AZw8Pq2ndz7IklQRxtz1GuWOBYAnh5vJVu4Xhs2asPRztVjtZ2zlEVs4VE/vl1Ye4o4QhiVTrpsaDQhfbLAIq8+J1WWxiRMaWcNhoMU2V7vC9KS7YrPS6FjhThNJQVUTOQFUyM8Dhb6/oGsRGvSPb3Wf1nhP7A8dzrP/yZSFrultEZu5HIkO26QSY3HQ0tQ20+TXDCSdpBVPp5q7lRO/mFPx2szfvNTOnB8BEintN656z9ey9w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9937ce9e-426d-4c5d-34bd-08d8496b21c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 02:52:54.6736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ENqB0e4zoijaAfRIr+aa4tg2x7UkhuxlS3FtikC8Y1E75+QC9uXxXAly0oumlaOGS1JmZZ8iMf5bgt56bAWO5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2363
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liang, Cunming would like to recall the message, "[net-next 1/5] ice: add t=
he virtchnl handler for AdminQ command".=
