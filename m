Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18F2242423
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgHLCrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:47:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:3823 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgHLCrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 22:47:19 -0400
IronPort-SDR: mGpHZhVyBTZJXFzeUCDCN9oG/vkpGQ8cOR/F2spOvq2AoABHwxm43wO93/ttG2fWy1nrYC4vy6
 NnIvFNB5WAjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="171916813"
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="171916813"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 19:47:19 -0700
IronPort-SDR: BVR5DebkZSu7ISYqGpYxGw7tli2csOhJNxsVusdFrxB5VytX/HiVi8bCR++eqRILCG5gynnmM6
 y3sJO9zqZQwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="334773546"
Received: from unknown (HELO fmsmsx605.amr.corp.intel.com) ([10.18.84.215])
  by orsmga007.jf.intel.com with ESMTP; 11 Aug 2020 19:47:18 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 19:47:18 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 19:47:18 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx121.amr.corp.intel.com (10.18.125.36) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Aug 2020 19:47:18 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.50) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 11 Aug 2020 19:47:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP+Su6Whbo6me6Ovh6w9IafaaPvqFYx0Qp/fRoxZIhlDXumPSvbcJzwpBCAZ873LEfxulcXh9Qb/WlhPO6iuOQ5j/+jgl5ACE2/6ih55f/Szx+2cCcLa/ztAE6xcwdnAHc7AYAR+Mtxf0QxWcJEasn4llNj9Cwa8U9VLPuezjrY/MBR7GiHvFgG1bFWtq6GdrkTPSonNe5Pwjw2eBFvmMM3fgx1A5VRT5ogpqhqvFgZQfz4Pc5xw2ysqFb3/itm5ZUIexjeR8/KGsBpfso9kJ9ltFPYoxGy6z0un/24WE3Q6vCSuJee0R87lozbS5QHfILw6xoDYpL2p+U148tzGWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gl1RCfUrfA47L4nVlNH5VB9K+f5GRoPOlTV3J2I7eE=;
 b=i+0ed272vVP2pYioZmqly9ega4aG+wlw1UgJEBoZVRgL0qYmqPJQiBKFlJVIzVBsvK/fhyonLSkOUqCD5B3fyfqanAODedS5p3jGFXjUv1SzoZ24edJzf6W4xTntKgvEfLy6B1eXQLXPl8OFbDrbzC7prFZY+tFGMCBhST2vCDPGwaQnyRKhtAthZNYLu9CAtmo5nri80sas5E9s2Cb/V6gU+ziv0TA5YvI6tnKuCfdcUw9+1PDAZ3qG9BEAYBOq0B8IPNqIyGYDUSBsjSkMQjI98F4pv0Ehcmlnh5ZOtbJsLHfOd2V03JcdwbkVjL4DzxMrq+8lfkq8f6kNq+jVFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gl1RCfUrfA47L4nVlNH5VB9K+f5GRoPOlTV3J2I7eE=;
 b=t7BJNYjMmHlzWMJ4vtmazqiP1uLN9issfk0A77P8YFAQTZZX5jigY8qHRP0mBN/MteJykbsONOSnFmxd/0rIolk9KldiqBmIk+nfCsTt717sSeppkclhZJNyoIzv3jj34FPBOwn0+jFSA9Dy2zTfVYpuNCizyv7xAVY9TCNPUyg=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR1101MB2141.namprd11.prod.outlook.com (2603:10b6:301:50::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Wed, 12 Aug
 2020 02:47:14 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3283.015; Wed, 12 Aug 2020
 02:47:14 +0000
From:   "Ramamurthy, Harshitha" <harshitha.ramamurthy@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "hawk@kernel.org" <hawk@kernel.org>
CC:     "Herbert, Tom" <tom.herbert@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Subject: Recall: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper
 function
Thread-Topic: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper function
Thread-Index: AQHWcFLiWAyzfusEyE+vctc/CmHq2g==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Wed, 12 Aug 2020 02:47:14 +0000
Message-ID: <MW3PR11MB45221B7EB55E723E670A650C85420@MW3PR11MB4522.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.63.191.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfd46711-4d29-4499-ab21-08d83e6a0536
x-ms-traffictypediagnostic: MWHPR1101MB2141:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2141B103F8C5AC98199C561585420@MWHPR1101MB2141.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eV3doxN0L+peyuZSeEiekHxsxcMyFmbU87ArHpZIULTKRbKO08+wcVYWWWYzJzA0VsAjoY6kV3YKQWICJ59jtxeEHdPED3DGw07acRESJHmuFGi6D6LM9wvkb2yYJlj/T2JQSuA++yF4pPf1+seCQGWcqApsgY+b/MrpK1cYwpd253Oi8tlQdY1Hvg4zDptWYSp/xswUfz3uGt6Y1He33rcRHNZLY2tigGCDbOH/csLu3UC1PGcPxgCtntFQ2/0I6fyDVcySti7wV+j6E9GqP9I+hSnsYxaUlNp/+nU0c8IdWvwR1ubBawgLHA8d55d7zXtG7nJ/xRj/5u6XofgJ9nmlDaMOIfAlQwBWhtmvpTn+QAblb95NU3JafRLjVboV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(66476007)(66556008)(64756008)(66446008)(7416002)(9686003)(7696005)(66946007)(86362001)(4326008)(8676002)(83380400001)(55016002)(71200400001)(5660300002)(558084003)(2906002)(33656002)(76116006)(8936002)(6506007)(110136005)(478600001)(52536014)(54906003)(26005)(107886003)(316002)(186003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PK6FQ1qDJTX2r6++rmkRuSVeUMzCr5Qe7p1jzmFHWxJbU1a4Bx/smkQ1YQbHaAR0JyexdT2CZ/lUhOY/OEgKGXaypJCHQqNOkGEkIxX5yl9dZK9s7jpCPYL5DZqjUu5mac6Cnji3OHO5DOAXKdayZqe2JztReYa++jelI8JsakbV3tHj0gwiGGB5H3eMcrwtiyz0+TiJd5r0H17wkBiAv+h1Psm+JKx2F6+7ZabJDC37ZOabXAUC46lG5IPwS66pjR2VPxitJ5B/WC/D89Hsw/jy+h+1wHJ2f9VEc7a1OyA3t4EUiaslBzQrw8u4rZj9XU0ASEYCOG8f44uSUJeO719+qAva0TMqVqvD4piOMOC7vXNBo+51j5SeAWLDTITcF2fAaWpHSlumFF5po/ArztRNZJNfJIjrifMFlkkVyQFJnrL5f67C5JaChGXoJWvxhJJwwTA1V/fc8jSMRlhLohYRyFHPUJxTJtG99CvuTJRzq9tj9lNzD5PYcgxpbBMdnuEOV8cYwueLcSf67Yg3ZpuOnSd9wDFhgkRpR17eodmI3ULd1P1n7dFWomlfv02OHkiN1sL/+QxX0yz/LHCy7XTtcAlYSU7J728npnZVG+n76dLjdmOui3JsvNlJpmMrVZcATv0mnpjj6xW4t3iZdA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd46711-4d29-4499-ab21-08d83e6a0536
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 02:47:14.5957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FygAYasxwq7wuZlOMpkB/WwmFItZR9EqEbbYPp8umP2/cnKaji2LQtLDRSnpO0YBmtSFVYmneuPOfdsdVxNY8/MZtqGMF7wno5zmfa6NMsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2141
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ramamurthy, Harshitha would like to recall the message, "[RFC PATCH bpf-nex=
t] bpf: add bpf_get_skb_hash helper function".=
