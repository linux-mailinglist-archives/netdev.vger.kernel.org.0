Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0537E2322A6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgG2Q0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:26:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:20925 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgG2Q0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:26:37 -0400
IronPort-SDR: oFS+SCve3Tf5QJk7shGnlq8OScJJuIb/WbzS/QnKz2zE8krCQv+wATXRpgjlu2isGn0O0S51do
 MsvWOyxi4N+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="215942897"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="215942897"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:26:35 -0700
IronPort-SDR: 1Inv5rA5pfzErEkwSt67D/enYSkjwIehID6k08L2OhNlmHjaoVoyyhiPrtZ0Vt+WhgzVeIafC0
 OQMB8Iloz1rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="330453738"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga007.jf.intel.com with ESMTP; 29 Jul 2020 09:26:35 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 09:26:35 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX152.amr.corp.intel.com (10.22.226.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 09:26:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 09:26:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RipaphT0zNY7qMHGM4NoQ8di3kW4WVFgbKLxcEeebXYcA1s3qO/S6W1rseVMaHNrgfXWPSIoJ7HmDejdRvIOEC75K9zAjXAV5a4MSCpBuOJ6NEbfR3SqrrFGsKHoxFrZYOoKYuCU/ihhtfQmu2yH276ucXZPLror50TbigSbJh9aNqpfkYerqIt97/tb1m1cFc4OMnmse9ERL/jHwAXOaXPo5xFadnU1dcjEnDz5kfIvNh6MY+1TKmlqhxErk4UCcE5ejnyra76Atqkx6HPi1oSrD22SYhxFU8wyOHgUgt5TOmslDH0VZexN7XkeGLI6r5FrFgumkzj7AnzJTbHasA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4x98xmnsueTUg95AAf+8s3NVoIZbUvrsnEgxltdtIg=;
 b=kKsv9xqINWCVJTYBLOpoA9+lqOAjC568VVnJi3rnuYQSBxiK3C0iKTgSnUfRhLHzLCpXiwRg0LuhQbdeQlYRF/lig8HWAJdOLeCKgsyhNZTCdBTRSAvcZq/j5zo1JC2+mcQz1Z1JO3sQu3lEyWSzMcBCpggQg/Ni1I/v4B/WBYcl06yPZwAfqLFB7sD76JO9JH0Lh1fduRwglZyAfXrQdwvhoYc7k3K4wBM6tkqm4dThx6/WtdYX2RjY0IIxERaEaB+peGcpB9fbB+j8T4JdUqlu/WN/fk2SQKEx3zY1k3MglAWq3wvYPDxT/l7RC1u1ojwMkvAn3mgYEUmrYi2yUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4x98xmnsueTUg95AAf+8s3NVoIZbUvrsnEgxltdtIg=;
 b=w0oXcwpsnZ3I1mumDgpFYblNlkFc6k3yrlisM35Ak60DSrUhP8gGrQPRTXPUmu6Rvjg0k9QGgWR5HzEv4KmrMi49YTpTySaSr8Eey43lj6eUfXQRiq6e1HAwKjswV/cY7R0XpUOHxAlAPj741XTLQdwS76/sD40vBp/D6g7kA/o=
Received: from SN6PR11MB2847.namprd11.prod.outlook.com (2603:10b6:805:55::31)
 by SN6PR11MB2543.namprd11.prod.outlook.com (2603:10b6:805:56::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 29 Jul
 2020 16:26:33 +0000
Received: from SN6PR11MB2847.namprd11.prod.outlook.com
 ([fe80::4167:fe21:b922:e059]) by SN6PR11MB2847.namprd11.prod.outlook.com
 ([fe80::4167:fe21:b922:e059%3]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 16:26:33 +0000
From:   "Patil, Kiran" <kiran.patil@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 05/15] ice: return correct error code from
 ice_aq_sw_rules
Thread-Topic: [net-next 05/15] ice: return correct error code from
 ice_aq_sw_rules
Thread-Index: AQHWZcTC7YwNNnixzkGtW++D9dYq46kevh/A
Date:   Wed, 29 Jul 2020 16:26:33 +0000
Message-ID: <SN6PR11MB2847EA0F57447F0CF6650B52FE700@SN6PR11MB2847.namprd11.prod.outlook.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
 <20200729162405.1596435-6-anthony.l.nguyen@intel.com>
In-Reply-To: <20200729162405.1596435-6-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.53.58.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 606318d3-9751-4d07-15fc-08d833dc2846
x-ms-traffictypediagnostic: SN6PR11MB2543:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB254355AAFF21485162CD25DBFE700@SN6PR11MB2543.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HpTw9vJmPeaZetJ7zHPupXyoVfnWcuiwcsN9pQiXYpfZXbzolURc2uHRJQ3KGAPHIuuwZeYe53I4f8US+zwBjQjVlbVgYy7pc/5zFdv6cECrSrFofz3USfcSRAwFl0n4VnMi+zMwGYp+n5Q5Y8e+2qTrAXskwHMds6yAjEO/XGECr8gDuZNsVT07Ed8/aTdbjEzf9yRTxGfCAN9zzv3waUFSJC2eM0LZFUdx4dwizNqPErwIak+4cQMstyWCA/d7nBNUVlpaqxUsIFsUJfRLktD85E5cCBAGw2qQQniTHAUuuKZzje4GVhdMuazkg1bY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2847.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(52536014)(71200400001)(4326008)(86362001)(5660300002)(8676002)(8936002)(26005)(7696005)(316002)(55016002)(66946007)(54906003)(110136005)(76116006)(9686003)(66446008)(64756008)(66556008)(66476007)(33656002)(107886003)(478600001)(53546011)(83380400001)(6506007)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0RMQHsEKhzLtRkZiQeX6XLrWJmewiWbtjfDKM/hlMngYI2t9vJP7QED211g+BoGDQXDbfTyI1gt5vFQA5olLk8WwYEchlIi8tjdNbsDGkP0IdI4AH/hy4+lD7/5S4ULFjNNh3hEUWstYBikwXprDmJODe6TeWm3moDITVjSFlYu5d1puYrKyx4x5gUWmONs6B7khvv1IK12uMg0j3T1my87EYfAeV7zZE6LeRwgRh+WzMySzXEIzaz/PW6YqIeYHqBmMQF/XmBWi9ZimbwlDSkQrslj4EC2EeFFTIY9NHuqUWtJD5rb0agJIdhXENMHKUc/sQnUyvRJHnp9sIZ25yZ/8ztjT5mG2+T4hfc8acnpQZ48DfXvqCE1oYdMSqFI6p/rQ22DRs5DKmi0f9dvZqXgqZx7OxklQsuuzGVI9OE8JCclIQxbmFOb8MkEJ4SKak5I1KmYODH7PUKbzjNcLJI/4boH1LbPCORLiht88K10=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2847.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 606318d3-9751-4d07-15fc-08d833dc2846
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 16:26:33.2769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r+wofTPcfz5zH93zM8HjilhJKO9awFDepKgPG+MmycIfx3gOZFBLklHX8uLQLb9tZULL/6yrBJjaZSA90OLVCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2543
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACK

-----Original Message-----
From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>=20
Sent: Wednesday, July 29, 2020 9:24 AM
To: davem@davemloft.net
Cc: Patil, Kiran <kiran.patil@intel.com>; netdev@vger.kernel.org; nhorman@r=
edhat.com; sassmann@redhat.com; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel=
.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Bowers, AndrewX <and=
rewx.bowers@intel.com>
Subject: [net-next 05/15] ice: return correct error code from ice_aq_sw_rul=
es

From: Kiran Patil <kiran.patil@intel.com>

Return ICE_ERR_DOES_NOT_EXIST return code if admin command error code is IC=
E_AQ_RC_ENOENT (not exist). ice_aq_sw_rules is used when switch rule is get=
ting added/deleted/updated. In case of delete/update switch rule, admin com=
mand can return ICE_AQ_RC_ENOENT error code if such rule does not exist, he=
nce return ICE_ERR_DOES_NOT_EXIST error code from ice_aq_sw_rule, so that c=
aller of this function can decide how to handle ICE_ERR_DOES_NOT_EXIST.

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethe=
rnet/intel/ice/ice_switch.c
index ccbe1cc64295..c3a6c41385ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -495,6 +495,7 @@ ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16=
 rule_list_sz,
 		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd *cd)  {
 	struct ice_aq_desc desc;
+	enum ice_status status;
=20
 	if (opc !=3D ice_aqc_opc_add_sw_rules &&
 	    opc !=3D ice_aqc_opc_update_sw_rules && @@ -506,7 +507,12 @@ ice_aq_s=
w_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
 	desc.flags |=3D cpu_to_le16(ICE_AQ_FLAG_RD);
 	desc.params.sw_rules.num_rules_fltr_entry_index =3D
 		cpu_to_le16(num_rules);
-	return ice_aq_send_cmd(hw, &desc, rule_list, rule_list_sz, cd);
+	status =3D ice_aq_send_cmd(hw, &desc, rule_list, rule_list_sz, cd);
+	if (opc !=3D ice_aqc_opc_add_sw_rules &&
+	    hw->adminq.sq_last_status =3D=3D ICE_AQ_RC_ENOENT)
+		status =3D ICE_ERR_DOES_NOT_EXIST;
+
+	return status;
 }
=20
 /* ice_init_port_info - Initialize port_info with switch configuration dat=
a
--
2.26.2

