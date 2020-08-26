Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324842525A6
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 04:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgHZCx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 22:53:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:43337 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgHZCxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 22:53:55 -0400
IronPort-SDR: ksrpq8SXazBDlEww+K45g701mZp8RNs0hjhN9KAXkeKmSrMzrVQJ4ANQxG52Idz6SvnW8pXoyH
 sTlxcApIHjKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="157267282"
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="157267282"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 19:53:54 -0700
IronPort-SDR: dH6XXCEiC1qVsEm0RNrN1pOOu4JbjI/Z0oeQIkUdi1f7Rg8DZqRPoVP44YDH+QF5B9ZuH28AUU
 EdWen+nZp95A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="329077115"
Received: from orsmsx601-2.jf.intel.com (HELO ORSMSX601.amr.corp.intel.com) ([10.22.229.81])
  by orsmga008.jf.intel.com with ESMTP; 25 Aug 2020 19:53:54 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Aug 2020 19:53:54 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Aug 2020 19:53:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Aug 2020 19:53:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+6a8TPi6+HVCMnTtIZYY049kUCPR3B+0LW0vDw68MXieH6CTRMDbkewI8Wf1VBFsQUc1by3yXUWd6+AxPNo69smLKxB/Se6uCMUKFoaccRio6/2uizBadyHTHZsaYKhybdpugzopJiUfObP+gJCIPNTse7NmDsqj8UpXDVdIKVSd2WTPTDIg9w0bJ0TQfI8R7n4e48ga3wMDv9pF2etW6L9kZK4jUKese45j/u2uyi/JtOqrAV4Ebn6yFXNDQMPm9A+FODzSPuih6QM1nYSEiu+zt4C+4skgsobT+Etpn8nKYRLXrFL6FZKjWwdtC9I9Sgo1rDdK9dtobOc9OzqfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5W4ZteAUx59er7c5B61Cifqmzf1cOWi9zT0Fxfem1mg=;
 b=P8xm+39Tn60OutZu/Szh5pShida9spor0A6SErqtvyGFydfACC8Z+WcFhktZQHVBvqjCBn/Sh/UKzQ7fvd3+nmwnuupKDCePf+SwP6QpF4MhJjruMxpr5WGJFv0ef0iQh2hhA25/cf8LluiQLTG/qN3cQKBkIYTjvIy5vwfXvKkiMowEdEsfEwiX7VH16bnDC8acB1dzEO9varOPKvsb6v3pSaPNUZF9VFe6tqAAps3OgwjzjvzQ29CNO2VYdXUFohmlpJcY9rxpXccoUMYmADnCL/a3dq+8q8afvofOEsODswW8CKsmPuvDXgPhG5Rq9M0AzjfGYTmOHSSRe5JRXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5W4ZteAUx59er7c5B61Cifqmzf1cOWi9zT0Fxfem1mg=;
 b=LEQDBJYDboTSVHphb9f4k1eXfpNtL2bP/n22FTRZnuo/0xLlhuEPPZE7cdZL3lbmAGe/hW9TooES1++jy8uUKP8ZSATJW06kS8nIjum3M1liSLVCbjCz0ZflEjHWAn12sSd7kFGzLvTxxFj9yLDrfvj7zbUO2UbTdd8CrRt1clQ=
Received: from DM6PR11MB2554.namprd11.prod.outlook.com (2603:10b6:5:c8::21) by
 DM5PR1101MB2363.namprd11.prod.outlook.com (2603:10b6:3:a7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Wed, 26 Aug 2020 02:53:51 +0000
Received: from DM6PR11MB2554.namprd11.prod.outlook.com
 ([fe80::b5ee:6a1c:925f:61c9]) by DM6PR11MB2554.namprd11.prod.outlook.com
 ([fe80::b5ee:6a1c:925f:61c9%6]) with mapi id 15.20.3305.032; Wed, 26 Aug 2020
 02:53:51 +0000
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
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NCAASN8gIAAbxpwgAEdaICAC25lgIAACEWAgAQpEoCAA5A6AIAKLx7ggACqkgCAAdqXwIAhFtPw
Date:   Wed, 26 Aug 2020 02:53:51 +0000
Message-ID: <DM6PR11MB25546FA7A35A763806CFE2FFF9540@DM6PR11MB2554.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
        <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
        <20200727160406.4d2bc1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795FA12407090A2D95F97C6F74D0@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200803134550.7ec625ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR11MB37951AC65BFBDF0E9BFBF86FF74B0@BN8PR11MB3795.namprd11.prod.outlook.com>
In-Reply-To: <BN8PR11MB37951AC65BFBDF0E9BFBF86FF74B0@BN8PR11MB3795.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3488a3e-d1dc-4bf3-48ed-08d8496b43a1
x-ms-traffictypediagnostic: DM5PR1101MB2363:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB23631C743253D97A547095E8F9540@DM5PR1101MB2363.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k/TfRMJF9BBoPkOSy7M9lryLYAKVqmGuItwPDyb/G2956nWvJVp1YVELGVkvOw9JzxI/4fg03Kbia4T3lKZhEzWVjBd3h8L3sa6N5KpFZ2XkTpWIyfv+XmlT1CoysrCjWSrZlzxLByIlU63xxFt4Jc9Pwv/Jp4FSweBp8a4/wjoIx2qpm4gvw9CWPE64bUuZ0JpEcrQ6ybN9+QqISTZMcsJFcPt79EwpN/dSML/FlueqsKkEfVfhfQG4x5cPsFYxdtbdEnylsx1U5qazeDiN7sTXwucQj+t3minJjoTp4mPN2F1gsMacCE7/xqMqeMYRHVohrD65snitqJeCaSQeh4Ibfueh/zNnV/h+ZmRN8PzyFtLV6qDIYxul9SZT0zWJoHvKKjYWQTJUEsA4NFwwag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(86362001)(54906003)(71200400001)(7696005)(107886003)(83380400001)(26005)(33656002)(4326008)(52536014)(6506007)(6916009)(53546011)(76116006)(66946007)(5660300002)(966005)(186003)(2906002)(478600001)(66476007)(66556008)(64756008)(66446008)(8936002)(316002)(8676002)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vCfTxFvyIc5/Rm9p/FVDQaqJG0RI3LBl5uikuv0yFEG7BoT4wHeKw9CuzogVgSqap2u1+GNFtrCtxMBPqIGk92lYr9rBpd7d0qr+7UkiPeIKutfAIWq0dH/yVVDP4q7FjsIOVmLAvT5MV6PkL21P0QvfFs73jpzuWfm7NexeAfSd3+ZYuoCLLUNI4LFAKe0GN5p5YaHaYW9Jg9Oz6KC+s3BW6KQagI2GsAp71eBan6/kJUGrfQdg0WntWoBWOeA1O+KDj+oeyTFWvVP/cxbymH9RLN+LGK4Ci5is7nUb6tis/UjJQTiPMI+e52L7+ir5m5QErwQpAQuxm4O78rBDQWd/4KOxeTr3c4ZCGo3HcORw2q8m370iZ9fdqb3e/lUgaeGZRac2PPuDxgwQIb0fSJH9IeN7+/dMxK7R6ilzEi8czUMBDaBViCou9DTkq8QLgMfYYHqR9rf2En/OYEWPtVQaRCuef0EGeSm68bLAUp+vgyyp7nFN+bPOY4Wu2IQvN5tneiY8VAhjvECZF8760PhhZombucNFqNX9zpUsjV951ylMe9y6by+RvThzYgmu5mQAsDVdONrmxPoie0veqRbznMfQqyQE4ruL1SqpQaaNn63jhXSje0EFo45+GDBlu+3XT4E1ihZAkxcyc0Z3IA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3488a3e-d1dc-4bf3-48ed-08d8496b43a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 02:53:51.5578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IST1SFK9fauxfq6ucUNeHQboR15Ili2nHBAYFY6r7DtFwDl5Oqzg8lQszFMdEpPCkXHY1G8IsQOtwR14mddJdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2363
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wang, Haiyue <haiyue.wang@intel.com>
> Sent: Wednesday, August 5, 2020 9:06 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Tom Herbert <tom@herbertland.com>; Venkataramanan, Anirudh
> <anirudh.venkataramanan@intel.com>; davem@davemloft.net;
> nhorman@redhat.com; sassmann@redhat.com; Bowers, AndrewX
> <andrewx.bowers@intel.com>; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.c=
om>;
> netdev@vger.kernel.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; L=
u,
> Nannan <nannan.lu@intel.com>; Liang, Cunming <cunming.liang@intel.com>
> Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, August 4, 2020 04:46
> > To: Wang, Haiyue <haiyue.wang@intel.com>
> > Cc: Tom Herbert <tom@herbertland.com>; Venkataramanan, Anirudh
> > <anirudh.venkataramanan@intel.com>;
> > davem@davemloft.net; nhorman@redhat.com; sassmann@redhat.com;
> Bowers,
> > AndrewX <andrewx.bowers@intel.com>; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; Nguyen, Anthony
> > L <anthony.l.nguyen@intel.com>; Lu, Nannan <nannan.lu@intel.com>;
> > Liang, Cunming <cunming.liang@intel.com>
> > Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ
> > command
> >
> > On Mon, 3 Aug 2020 10:39:52 +0000 Wang, Haiyue wrote:
> > > > In this case, I'm guessing, Intel can reuse RTE flow -> AQ code
> > > > written to run on PFs on the special VF.
> > > >
> > > > This community has selected switchdev + flower for programming flow=
s.
> > > > I believe implementing flower offloads would solve your use case,
> > > > and at the same time be most beneficial to the netdev community.

Jakub, thanks for the feedback. We proposed the previous solution in our ea=
gerness to satisfy customers who were using mature, and validated (for thei=
r data centers) host kernels and still enable rapid adaption to new network=
 control planes.

When revisiting the real problems we were facing, basically we're looking f=
or a rapid self-iteration control plane independent of a mature deployed ho=
st kernel. Definitely kernel is the most suitable path for a control plane =
and we need to enhance the kernel to add the missing piece required for thi=
s solution. Best way to achieve this is allow such use cases is to deploy c=
ontrol plane on latest kernel running as virtual machine. We shared some th=
oughts on netdev 0x14 workshop, attached link as https://github.com/seaturn=
/switchdev-trust-vf/blob/master/netconf-workshop.pdf.

As a follow-up, we'll continue work on tc-generic proposal and look for pro=
gramming rate improvement. As an independent effort of enhancing tc-generic=
/switchdev on trusted VF, delegating device specific capabilities (e.g. esw=
itch) to an assignable trusted VF brings all the benefit of a separated ker=
nel to upgrade up-to-date features in the pace of applications, and always =
prevent host stack from any connectivity (e.g. stable access) issues.

Will be happy to answer any queries...and thank you for guiding us in the r=
ight path.

> > >
> > > Jakub,
> > >
> > > Thanks, I deep into the switchdev, it is kernel software bridge for
> > > hardware offload, and each port is registered with register_netdev.
> > > So this solution is not suitable for current case: VF can be assigned=
 to VMs.
> >
> > You may be missing the concept of a representor.
> >
>=20
> I found the concept, thanks, missed it!
