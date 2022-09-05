Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2ED5AD9CE
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiIETln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiIETll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:41:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77815070C
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662406896; x=1693942896;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/QRCCsvG8qOJBmRdC2ELSmb4XJQFIgayRlYZwAvrIc0=;
  b=I7gT0QszqNo3j/hl0it3vjpDpLhQdwJ8xfKbw9SBJiAehVttAG8dCzdK
   RMI56AU/DD+S2tY786X4u88BbkfzYjx7idotRF8c4f7TkEYjZ++gQJ0Js
   OjnMHey6mnO9h4lh+fZfSrujyU6+Ed9t3RO+XfLQ5QYONkdeMeDE02eA0
   yUJg5+a5Lnl7tSoOJ3aovQ7MUxg4PHOZNi0yxVEuVq2/L8dMOFSnGfduy
   UDvGIXAV8RVAE78yjvE5vFw059yP/0jzc4b8vun/Zaxx61GrIBflRjAPe
   tkfEz47sP6f2rvaFEKjcadm3j5EbWjF9qh6yEqIqniNZJFhQBG3YZj90g
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="358161246"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="358161246"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 12:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="646993006"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2022 12:41:36 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 12:41:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 5 Sep 2022 12:41:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 5 Sep 2022 12:41:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMb0BRrEmOG7SQ3QmgrViVKQjxFdoyvAptcDNtgwH1bwFbQoPvWh1OcjHkXuC4UqGtoVWA/GDtE5L2PrzATltctrJqwRxpcpWVUA6F9WzSMEHByOMNq2iZ2FE9SUP+Y+Eg46LE4Qg+wq+188seXaEPy1b7ixbFrulXoIado+2U8xjaPIxumh2b+9/IKeNuO4WLyhXtKxp2atKThnaw7+M6sr6ReL0RTI3QzcUSw7zCC39AS3oCwbPpzd9zHow7dyzMC6GMsH0wpGpVpJQ/hFV0lHaDCoFDlF61ohxksGfCpzgESJQUQryqqdZIf/+k9VX7/pZO2CLWDWHVJtE04OYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QRCCsvG8qOJBmRdC2ELSmb4XJQFIgayRlYZwAvrIc0=;
 b=Zj8LQp623mQg191zt7/DiQb4CI/8KbUgeTPvVGZ+khiQESvnjxcPcJNigrHtOxQL3jjqip3yATF6aL3KFaZyynFOobeOqkotOp2+L++x/jYgpfJFoNbj+9PT1ddVId49+hbHGsbrGvCcD3O6GqR6qUMgAeR5DqCMDL8Bx/+PzdV3yzS2FghvuBFwiiJD+QpIPPGp0MHja9h7Aucd+Ix+NstAP/zNjFB+pG0bhwcB10okxfkmsWqdFySH949Y29Z0qH8YD5NdCfp+thFaa1e2NUl5eT/ZCPh0Y7VzLFZCWKJS0+39cJDQc2gEwsmvK6/t7pzFA7O8JjKOdcH0aI9v8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by BN6PR11MB1444.namprd11.prod.outlook.com (2603:10b6:405:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Mon, 5 Sep
 2022 19:41:34 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::40b5:32b6:ab73:3b8b]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::40b5:32b6:ab73:3b8b%7]) with mapi id 15.20.5588.015; Mon, 5 Sep 2022
 19:41:34 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Johan Hovold <johan@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: RE: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Topic: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Index: AQHYu/L55I/9qMiXWE+dtrk9hjKUpa3JkKOAgACUJACABx/9MA==
Date:   Mon, 5 Sep 2022 19:41:34 +0000
Message-ID: <BN6PR11MB4177480C375591CF5BA8E812E37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBU5AV4jfqaExaW@hovoldconsulting.com>
In-Reply-To: <YxBU5AV4jfqaExaW@hovoldconsulting.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78193112-e224-446a-b0ec-08da8f76a3d8
x-ms-traffictypediagnostic: BN6PR11MB1444:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YDDayQ2WE6EPH6QzFa23oEWr+Kjzr+v5IsJ/lPnC6GLnyiQ1pAmrqPRSSfIxeJPPAYlyGsLoEADbKbsQvTQmSIM0sdh66f2YRxkEGSQ+Jx3mbn4aOEfIlGB07xHESWmw6TlzGnRxZ/2RHfuxSeeHlROs4tyaAHrGU1XGfmaTx887MCSXQTOrF36mbLE64HOjjLqqdRI/OBSdtCJe/4oVWYW0Mm26UPero1xrvnCcTehFV9J5HkiZqhjbKuI1WyYtlUCMhXXzS59X32RT2NeSZyHc4ui6vRpIFvcuKN6PqsVAKphJx3rRpAPxKoY72WR5aa2JbCQ5uk7/LS6R3f+ECjOd8nPEKiIpg4b/j6WVZVIbIRlTbnNZiYZxxHCYPKGoGuklWS0KXbbPSBu2PuaMRFUEknRTv+BOmsAqHJlDN7CvekvRFQkYSHm4GdRsdEPrxe8TS1HkUXV5NvT9l2U2D3GuSv9mvLDTa8UcdPg27KdGdSBfULuyVh0zqyHog7LQAERiQlgyFj+AOUMo6EEGIiCx/RZqhalVQV6HQi+WiIpLgwdu0A0SF6mM01yqCuIMvXPBeO9tkMTJV5QKTgtpOYmV/IFKTd7L2cS0CCwZtT3grMUhMxwF69hpW3pr6JCIzYGSsYTIb/zAJibczYc1VkI0IkRhJkKZqT7+AikdSjWlIcV76Apn/nMS4F3ThOYXnQj4mk/HEXhCnf1mHYGFZwh4t+UBY/+7SZMAgWaX/HzyafqtjymfpBCQyekxwK3oqpNzSdR7yvBw+opNDezncA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(346002)(39860400002)(136003)(53546011)(478600001)(9686003)(83380400001)(52536014)(5660300002)(2906002)(8936002)(41300700001)(7696005)(86362001)(33656002)(186003)(6506007)(71200400001)(26005)(38070700005)(82960400001)(8676002)(55016003)(6636002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(110136005)(316002)(54906003)(38100700002)(122000001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RqYdYo5ChD4yiQ69Xlha+1SuUmREoe0dI2vL10mq9ij0Jdg8XkJbgE3FyieT?=
 =?us-ascii?Q?oqnt5f3kkHnF6v1hTMXvb3EwAagvN2a6GRbkhQlh307ovvGsZfGz+QiRVI39?=
 =?us-ascii?Q?9uC+vPhVfOzRL6CVQX6dahZQZMd2f8dKgzFrR3X9U56DWAVM0nYHuIGmXdv/?=
 =?us-ascii?Q?6PT7Unlf/WkVep/atv6UxWiu/dDPEYsLyNmSuVJOFl2ClhbPf3L7Ks94AHmj?=
 =?us-ascii?Q?8vcQkNRQzpj6diZfVqCSqKW2R5kRBC4UdF9ckJJ6eptvLw8jN9zO99BGdZS9?=
 =?us-ascii?Q?bqH6HJRqxAcuPGsGve3WOoJWGLiCmL49AmgWSl3dJSHl6a0xaM0nT/j/7Ip6?=
 =?us-ascii?Q?Y6Fg9mnLVxQPmc43PhWxcCcPiH4lvDB10PvpKpXyt9Pj+znKPKt/yJe0ozZb?=
 =?us-ascii?Q?zBts4156blRgvSVfOoEHn/FSTR6a4yPmi33wV26eJKPtz4P4mpjHCB7UZYAH?=
 =?us-ascii?Q?4sknZQNntkarbdv/p9nDlGoFWcMtZGL3uvY23BVBrs3/NqXgmzRwqOOvhIZz?=
 =?us-ascii?Q?qYRt9PdvTPlVRu7eUkkUAtzZLZj20yQOXUbr3hjLWnLlMscDOZ1iEdrICOnM?=
 =?us-ascii?Q?59J44XcSPqsMTjJyx7R9CYSqqApCN3+7ex42KnacBlzvOEVNRT169Nz9Wzxa?=
 =?us-ascii?Q?dpucdxEhgISroph3g/Ei19yBKN0msoIlxTSJmN0pfN093f3/N2WXDj5YdGQa?=
 =?us-ascii?Q?1KiA+qLyAuhOkcbQ8BKF8MczMEOeruEpnLDSb4I9LnfqetBGWMu5L1Elpg3P?=
 =?us-ascii?Q?F5L7z+qej/PHkQOonH6zROy30i1efC+KDeG9D5BBsXoxPwr61IaEuoApbaPx?=
 =?us-ascii?Q?Q93Q+Jcekoxipn/7w9Dc3wKL5E7ALd0TYfL/9y9h2GefY3M7tG3VAhNUdHqL?=
 =?us-ascii?Q?9GyRsuLd/uZPQVYH2cPW2Ee7a/SYMrYjV+4Ds0e1jT1zPhhpU9nv8NUYoGwS?=
 =?us-ascii?Q?t6q408G7Lw7iXOLRzLsF+2vbg3UhUfcNVADa2EkkCL6rZGhgi7DAzqWVtC/F?=
 =?us-ascii?Q?0GmS0aGcLM+pIn5WnuvcWMAvVRlX5iLe+4+dkP689AJkWtDdeFMnfcvJWNcU?=
 =?us-ascii?Q?X9L0w8lvrMDmus9qIrzRsvEneP8cRkQZ/qTTDVleYscPMqLwSZNCrWF5s+8h?=
 =?us-ascii?Q?aUBIiy2ffjtBMx2p2s6+zGmB5+u2d6K9/e7eYhzCU2K6XIJI07Csb9vFqkWE?=
 =?us-ascii?Q?BL1PjZ3Q7Up2QfrLRvWIl9ZWc0S4ZdUKp3VFsVO8jmchISGR5pPmtb+DjLfU?=
 =?us-ascii?Q?E7jW7e7lmvFAezvxtEtBQr4eyGXH0PZpjAzjKBajy3w0WW+9N58unH4IxJph?=
 =?us-ascii?Q?sALgFEA2xyOg/O+Q1hNEOnRlQje/Jh6NxbLp8UiPfZ1Lqt9bF3ctySqRSfL+?=
 =?us-ascii?Q?cjAhXm9Xq0QGIx+RD3tpbDWPPaJoHPxCMJl7/hcI/VVGvn4c4U/jkr0+13yI?=
 =?us-ascii?Q?JJKHWePzIulOG5IPiFjp8eUi9THMwuqbmu7TM1loZ05xTXsf7NJN+BysMgt7?=
 =?us-ascii?Q?N+9RtVRv0TBsKIUVagQlHz/ug5fs+JUEPF86snk7IJ58my6IXjJGPK30ns5h?=
 =?us-ascii?Q?3yP5KC54u53MHfE66f0/qGqqZrHyVbkqqLFzU29QiVy6kwyopHNUekF8wxp4?=
 =?us-ascii?Q?Ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78193112-e224-446a-b0ec-08da8f76a3d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 19:41:34.3521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IaqT/3+KT18fQImFlQkMiFOaS9qblpLeks5hi1HV7Rf2iWI5w7IM4XmtAAs9HG8x8mDmM9Re7WCN0KwS51Y9UuSlrVVHdrSAuc4u7kRrfyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1444
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Johan,

Much thanks for valuable feedback. We really appreciate that you have point=
ed that
problem so we can fix it as soon as possible.=20

BR,
M^2

> -----Original Message-----
> From: Johan Hovold <johan@kernel.org>=20
> Sent: Thursday, September 1, 2022 8:45 AM
> To: Jakub Kicinski <kuba@kernel.org>; Nguyen, Anthony L <anthony.l.nguyen=
@intel.com>
> Cc: davem@davemloft.net; pabeni@redhat.com; edumazet@google.com; Michalik=
, Michal <michal.michalik@intel.com>; netdev@vger.kernel.org; richardcochra=
n@gmail.com; G, GurucharanX <gurucharanx.g@intel.com>; Greg Kroah-Hartman <=
gregkh@linuxfoundation.org>; Jiri Slaby <jirislaby@kernel.org>
> Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle t=
o GNSS
>=20
> On Wed, Aug 31, 2022 at 02:54:39PM -0700, Jakub Kicinski wrote:
> > On Mon, 29 Aug 2022 15:00:49 -0700 Tony Nguyen wrote:
> > > From: Michal Michalik <michal.michalik@intel.com>
> > >=20
> > > Some third party tools (ex. ubxtool) try to change GNSS TTY parameter=
s
> > > (ex. speed). While being optional implementation, without set_termios
> > > handle this operation fails and prevents those third party tools from
> > > working. TTY interface in ice driver is virtual and doesn't need any =
change
> > > on set_termios, so is left empty. Add this mock to support all Linux =
TTY
> > > APIs.
> > >=20
> > > Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
> > > Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> > > Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker =
at Intel)
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >=20
> > Please CC GNSS and TTY maintainers on the patches relating to=20
> > the TTY/GNSS channel going forward.
> >=20
> > CC: Greg, Jiri, Johan
> >=20
> > We'll pull in a day or two if there are no objections.
>=20
> Hmm. Why was this implemented as a roll-your-own tty driver instead of
> using the GNSS subsystem, which also would have allowed for a smaller
> (and likely less buggy) implementation?
>=20
> Looks like this was merged in 5.18 with 43113ff73453 ("ice: add TTY for
> GNSS module for E810T device") without any input from people familiar
> with tty either.
>=20

Original author is off, but to be completely honest with you - we most like=
ly
did not noticed the possiblity to align to GNSS subsystem. That is a mistak=
e -
we are working on understanding if we can easily fix that. We will back you=
 you
as soon as came up with the solution.

> Johan
>
