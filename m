Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799874F66A5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbiDFRRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238969AbiDFRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:17:34 -0400
X-Greylist: delayed 3253 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 08:13:25 PDT
Received: from mx0b-00273201.pphosted.com (mx0b-00273201.pphosted.com [67.231.152.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A80541557C
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 08:13:21 -0700 (PDT)
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 236BW4Zn024199
        for <netdev@vger.kernel.org>; Wed, 6 Apr 2022 07:19:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=ynzhOyCcWK8s6Iy3QYgRgZVF9ZlSWY//iTMAKwHLpWM=;
 b=vKtNRO+OzRyVaBJagf6NXw7JbdH5r/8XBmHWUul2Sl4O1myzaVcnE9zEYe4vuvS+BZQo
 ZPWZPhvRJpOn4kKN+/zC8dNnuvVa9qhjdTE7bbUHQ96umkeZcBWgsn/FxFn0XKiWqNiw
 EDlnSf5+3Uv8knkqepL9oPOoM5uA9f65ZJnKiG/rjVeyeDZBSlpcPrR99iB32uzzqoG9
 20MGgZNv0ZOeuH1VTZr63DCGXzvvsWqWD47PnoQIUi8Fs4jN2Y9YkZQ9IF8aFyQpcLOM
 7G5LTdA3ZLC0TdxQZSihH3ZW8j5tZWiNenyH2SQympbzyZ+w5V/W15Sd6zJ7QSIxJVjv dA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0b-00273201.pphosted.com (PPS) with ESMTPS id 3f8var25u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 07:19:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glcdl8j15ZEnKxiiNjUsGoNyVx7moF8hEX8+lVMREEFQelvCvYgcZ4vs063hWy2+6xcDf1NzyoecOuzcFlu1y5KWqcaZ2unPFAKfDipt+7dpoFzbnqDY1YTCflG5nQbo0rZpmbkDZxO138zOGCQwg06wTfPTkwAeG5Y5fyFzUUTgDJao/O1IDkW5LPHb/cw4iTO3cVcQtIv7gVzyUo1ZHVm7HyHfasakS1YCoRzLlJBWbsIiB5jtqUn2f8u/dWJYCMAVhlkehO/uqh/fS2BJ1LYusedibvcqPz1U4jmEwOXHd9N8yQJ9lKSEY1n2jEaKGp2afs3Djxu48qh2ZvzEjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynzhOyCcWK8s6Iy3QYgRgZVF9ZlSWY//iTMAKwHLpWM=;
 b=B3ScIusXHeQRSo/3tj97FmW/DWagBCZtVbU9Ht6BSg0ELcE1bGDovlpt9CH+M79Qb60OjLcfVA0JNsMN2LqBsuM1AKdx/Fs6UJ+z752FrxznO7a3/jrc015aTDTvEAnIbVkkldL9FRXPT2WCNzV/ZjdmXiSiLKgG/c4XTPT1ZRqWFXBBuUtmpSakZtzXwdKcfgor/Mor7S9NJqV1V6F9OQeY5P6S2hdNmt66zK9EFl1ML6zEObLwWPhwRpnisOoVTiarHcD7ZUIQll5GtjYhBhxqew+VKKs/GEc4pHFtWev9L6iKgJ6xcPHDRjJhhntlWERiPMic/9rLJtb73nvFTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynzhOyCcWK8s6Iy3QYgRgZVF9ZlSWY//iTMAKwHLpWM=;
 b=kWEjf0GOrkquV209cFdr/QeLegq4LnmAHEmC/vnYL+DZEcHamzMHQbHDhmXYH2sT5UEVtbuQVcwwbQC7rHmXJ2PAC8wXMo01pGPu1WSq8QEWlWxuNjukRtJIX8mHUyiAtTsfgoqUmuKcOzXe9xVI4+8MqBr4735ZK+ynxr4QtEA=
Received: from BY3PR05MB8002.namprd05.prod.outlook.com (2603:10b6:a03:364::8)
 by BY5PR05MB6881.namprd05.prod.outlook.com (2603:10b6:a03:1ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 14:19:05 +0000
Received: from BY3PR05MB8002.namprd05.prod.outlook.com
 ([fe80::61f9:1a95:d910:a835]) by BY3PR05MB8002.namprd05.prod.outlook.com
 ([fe80::61f9:1a95:d910:a835%6]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 14:19:05 +0000
From:   Erin MacNeil <emacneil@juniper.net>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?Windows-1252?Q?TCP_stack_gets_into_state_of_continually_advertising_=93?=
 =?Windows-1252?Q?silly_window=94_size_of_1?=
Thread-Topic: =?Windows-1252?Q?TCP_stack_gets_into_state_of_continually_advertising_=93?=
 =?Windows-1252?Q?silly_window=94_size_of_1?=
Thread-Index: AQHYSbWlBelgljcGs0eiXt3j1RXkZqzi7nIa
Date:   Wed, 6 Apr 2022 14:19:05 +0000
Message-ID: <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
References: <BY3PR05MB8002750FAB3DC34F3B18AD9AD0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
In-Reply-To: <BY3PR05MB8002750FAB3DC34F3B18AD9AD0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=True;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2022-04-06T14:19:03.731Z;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=Juniper
 Business Use
 Only;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=0;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;
suggested_attachment_session_id: 1b0a30a1-29c0-3d4a-82f5-be58c6cc080a
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab9bac76-8aaa-4462-6939-08da17d8685f
x-ms-traffictypediagnostic: BY5PR05MB6881:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BY5PR05MB6881CB585984067736CAA2FED0E79@BY5PR05MB6881.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V9bNA0XglzfxBSl+/r5cO7qS8Pq5drs6hWXDg99rJBwffnsacFXDdTz245CbCThP7U8NCpNSkPfwG1fKITMBMx9SQsk1dmprXous06ZGbnxN0yDjg1TpyE1ieEuJ33LcpSLYdw7iSVGytUvkxnCU+kNruy4S7OudYCc/QD1waHrvKs5bbcRz6O5IJdm2SDnwLYYunEOBehMDNOk2AqTldIlxR6Ie9juJdqJ5maImeeo1gDYM06iOXLc/RjKhAnlgRYFEATP9rKzpfRkLOSI/6feaUx8Cebltt1DXEZiPLgMlR24GyPGGk4QTdfROrArhItgM2HMhncSV+T6lWr1jycol+USBCMG1vqhRwQdX1T2Sp9pS4gyCYDrfQJhczMsgVOVrVvmqtUMAOkbx/IAMXTu0Be/fcA5gZjxPSXzu4SMx1bhPjfYYq77pCyyUgcC7dLA0UGYWpdZIbBxSpBSQEjPCSOePQup4ptMUlJF1mQzPsOHwXQhXMcY2QMDU2Cx81MeV+sZERai6fqq5GW970JyqyakFqOnOVtVLa4xgZdpRc/8XZue+ud2D04HblD2/pRCv4fmaE7wC79ekxSVJuLb5BkMPpbhEQsScIQHMsMUJqeft6XOgXzRKh0jwFSXYOESVWLxtge7J9JMnVAY8WTyupi3jf84MqLExpXGs9rmigRDmZwYK9pQ3DrMEmIYagnC71mnihTSU/qhfERghAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8002.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6916009)(26005)(2940100002)(9686003)(83380400001)(186003)(508600001)(71200400001)(7696005)(6506007)(66556008)(55016003)(76116006)(5660300002)(33656002)(38070700005)(2906002)(38100700002)(8936002)(52536014)(66476007)(64756008)(316002)(122000001)(66946007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?m4LiNy5AcuRKgqCKR7YojjCqDl3fR/bL4QPAaEhDm6c9Lufl3NbohsmP?=
 =?Windows-1252?Q?vBGHp58wjhJvqOjuy9x02GEaVWK7x2rCyqOWV4ViqWcRwfFme2pAIzDB?=
 =?Windows-1252?Q?WshtzzIHO32WteFlrlyLA5e0avK2soThbg50R1PahV0M7yI0I4B8RLwo?=
 =?Windows-1252?Q?KnIicCAO1ZzutQCXeYIyVU8OEu51EC2FR/pIRzBW8BcFi4RIJt6z4KG+?=
 =?Windows-1252?Q?yHU501jQn1TdcHpLKKUyR8zoKkatMJDwLP6AgqKXyt8FhmtqrTGWVFL0?=
 =?Windows-1252?Q?DJEbALOxi61orQSd8cqLbdtHfc4WRsESe+gdjWmrQP51qvHGoZUeZvSS?=
 =?Windows-1252?Q?Fns2NxqHUvf8HVSeZ63tlWQ9dEyLrgJ0i+dXkgSmLk6fH8uISYdvZ4Bz?=
 =?Windows-1252?Q?2kRNBbxSAHmw52ZwQorZ2DsIj8EVgfnkOPHdejFWKeotQbsXdbBrCuPI?=
 =?Windows-1252?Q?/gKWChiDy9fUBG6RRhv4SzA9RnFiHy8MLABzIhGNpzcb7EHiKCa0e6Mg?=
 =?Windows-1252?Q?wZZl4niNRPAe+NcoGqedqtuoBz8yuvoUwvZPOBtV+n+5TZbtbVStsFIm?=
 =?Windows-1252?Q?pc2BJzzjz/TL0PeeUrF2K5hZBHQHkd+HKsMSRNXeWF0wgsi0LC/DGP64?=
 =?Windows-1252?Q?21sp+fanCOd/UI+G+w6jo+Q9Kjkz6fzGlKK+5MJLZV3Al6uWnWyz2B41?=
 =?Windows-1252?Q?OQ8aUxmRZ+/4qb6oek/9eiCd+c2+eSDCtXLwEILFCzCg7IV8YUHv9E/q?=
 =?Windows-1252?Q?c+t52BdeZQydhBEjsEccuD+IPmCct4ojwG2LJL6SS95qt5aoSV5AToPM?=
 =?Windows-1252?Q?sb4TCC37LumL9QiIUiqOhT0ATmUOU2l9Et5abDvx2paSyM3Oq5zV9nfJ?=
 =?Windows-1252?Q?zkUEHuIK1G2RXwAcjOQqM9CelfGbKZbZCIw8bEXuo0cfQJZfp63mhq2A?=
 =?Windows-1252?Q?o2PxiR8gVGY8swdnsbMhS6Crlb8m2TOXv3qPEHjnaZOKOS0ghyKlxLfx?=
 =?Windows-1252?Q?6Mezj2MxbIiY+L9Z3cdhLOlmy6aPqC8x3eVp+lKwQib+kj6y+uOLuW9M?=
 =?Windows-1252?Q?AgmqFru5+/B7W8RKn1/jEH3HjXDcbR4kRSnvAJFs0AAPtlYA0nt8Uudi?=
 =?Windows-1252?Q?lyq/AFi3EPpUAOxBLbQq2LSgYpcMNTwa5vjrTk+LH+l2YIEU+WcKSyjY?=
 =?Windows-1252?Q?9GrJQfk1HDyY6798q4jLVhb9YNbJ6gDcpvdrKSxEWDBfpIG3pbFSFvKh?=
 =?Windows-1252?Q?lc+4bGS63S2x+tWd69M7qYS1xQ5eIAkIR+/YQmRDGy2WBZhQs8Tx9pxR?=
 =?Windows-1252?Q?DRQEfiPK+nUfTIy+UrUE62qR5gZ3RfNXBKp/+2dBtg6NtboEBq2nsqdB?=
 =?Windows-1252?Q?LOScwV9aY2o+XS9sC3a9yBb8ME/57qqUTzGoYs3AjmA2fD6cWRLAeDvZ?=
 =?Windows-1252?Q?/b8GfHxjNz4j6QGzYRGv2bm/k7On1dSMslidc/U6Ir2cZRbcXeF5ZkHc?=
 =?Windows-1252?Q?eXLjFttZv6Nxk6HoomdJKtEa7I7kVCYBvYuOiT2pgdimOb20VwsprRuW?=
 =?Windows-1252?Q?pemVILGuvMq12oSDj3in1XixOq1GqLgTJdqqsxRk45qtjKM2zxWLiEXc?=
 =?Windows-1252?Q?lqLM/owlra42L6BnqADgeDHXPnjM5RLfQeMA/8rZpzt/TLr7m3DfX91D?=
 =?Windows-1252?Q?NbWMxHQ2LcMWC+DJXFsehMwS1svsBRvk6h79QV0AwGpNOZ4DCIhg1vpa?=
 =?Windows-1252?Q?Ak7XCqKcysDombzSM/Q8ldinh/iSYMq5iWYqakVm2sKmtghATrPq+KMR?=
 =?Windows-1252?Q?Jq+IWx+eiR4qzUUwv8z5vk/cbJKS/9q9K57AJ2j7EjGblQDQKVl7bnxZ?=
 =?Windows-1252?Q?E6JBmnuVmBzkjg=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab9bac76-8aaa-4462-6939-08da17d8685f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 14:19:05.4211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewYMhBYeQSHz0OgY/EsS1oovc8WJZaAnoA3DO/7iAHUoxeEP2pINhHC7bXy4VB/fMxrtc8xEPHSYHfjC5Dyj0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB6881
X-Proofpoint-GUID: -JYcTOqmYAaQ2kouz1NwBjb9fpLNMakL
X-Proofpoint-ORIG-GUID: -JYcTOqmYAaQ2kouz1NwBjb9fpLNMakL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_05,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 priorityscore=1501
 adultscore=0 impostorscore=0 clxscore=1011 mlxlogscore=759 spamscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue has been observed with the  4.8.28 kernel, I am wondering if it =
may be a known issue with an available fix?

Description:
Device A hosting IP address <Device A i/f addr>  is running Linux version: =
4.8.28, and device B hosting IP address <Device B i/f addr>  is non-Linux b=
ased.
Both devices are configured with an interface MTU of 9114 bytes.

The TCP connection gets  established via frames 1418-1419, where a window s=
ize + MSS of 9060 is agreed upon; SACK is disabled as device B does not sup=
port it + window scaling is not in play.

No.     Time                          Source                Destination    =
       Protocol Length Info
  *1418 2022-03-15 06:52:49.693168    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      122    57486 -> 179 [SYN] Seq=3D0 Win=3D9060 Len=3D0 MSS=3D=
9060 SACK_PERM=3D1 TSval=3D3368771415 TSecr=3D0 WS=3D1
  *1419 2022-03-15 06:52:49.709325    <Device B i/f addr>   <Device A i/f a=
ddr>   TCP      132    179 -> 57486 [SYN, ACK] Seq=3D0 Ack=3D1 Win=3D16384 =
Len=3D0 MSS=3D9060 WS=3D1
...
   4661 2022-03-15 06:53:52.437668    <Device B i/f addr>   <Device A i/f a=
ddr>   BGP      9184
   4662 2022-03-15 06:53:52.437747    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      102    57486 -> 179 [ACK] Seq=3D3177223 Ack=3D9658065 Win=
=3D9060 Len=3D0
   4663 2022-03-15 06:53:52.454599    <Device B i/f addr>   <Device A i/f a=
ddr>   BGP      9184
   4664 2022-03-15 06:53:52.454661    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      102    57486 -> 179 [ACK] Seq=3D3177223 Ack=3D9667125 Win=
=3D9060 Len=3D0
   4665 2022-03-15 06:53:52.471377    <Device B i/f addr>   <Device A i/f a=
ddr>   BGP      9184
   4666 2022-03-15 06:53:52.512396    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      102    57486 -> 179 [ACK] Seq=3D3177223 Ack=3D9676185 Win=
=3D0 Len=3D0
   4667 2022-03-15 06:53:52.828918    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      102    57486 -> 179 [ACK] Seq=3D3177223 Ack=3D9676185 Win=
=3D9060 Len=3D0
   4668 2022-03-15 06:53:52.829001    <Device B i/f addr>   <Device A i/f a=
ddr>   BGP      125
   4669 2022-03-15 06:53:52.829032    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      102    57486 -> 179 [ACK] Seq=3D3177223 Ack=3D9676186 Win=
=3D9060 Len=3D0
   4670 2022-03-15 06:53:52.845494    <Device B i/f addr>   <Device A i/f a=
ddr>   BGP      9184
  *4671 2022-03-15 06:53:52.845532    <Device A i/f addr>   <Device B i/f a=
ddr>   TCP      102    57486 -> 179 [ACK] Seq=3D3177223 Ack=3D9685245 Win=
=3D1 Len=3D0
   4672 2022-03-15 06:53:52.861968    <Device B i/f addr>   <Device A i/f a=
ddr>   TCP      125    179 -> 57486 [ACK] Seq=3D9685245 Ack=3D3177223 Win=
=3D27803 Len=3D1
...
At frame 4671, some 63 seconds after the connection has been established, d=
evice A advertises a window size of 1, and the connection never recovers fr=
om this; a window size of 1 is continually advertised. The issue seems to b=
e triggered by device B sending a TCP window probe conveying a single byte =
of data (the next byte in its send window) in frame 4668; when this is ACKe=
d by device A, device A also re-advertises its receive window as 9060. The =
next packet from device B, frame 4670, conveys 9060 bytes of data, the firs=
t byte of which is the same byte that it sent in frame 4668 which device A =
has already ACKed, but which device B may not yet have seen.

On device A, the TCP socket was configured with setsockopt() SO_RCVBUF & SO=
_SNDBUF values of 16k.

Here is the sequence detail:

|2022-03-15 06:53:52.437668|         ACK - Len: 9060               |Seq =3D=
 4236355144 Ack =3D 502383504 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.437747|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236364204 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.454599|         ACK - Len: 9060               |Seq =3D=
 4236364204 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.454661|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236373264 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.471377|         ACK - Len: 9060               |Seq =3D=
 4236373264 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.512396|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236382324 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.828918|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236382324 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.829001|         ACK - Len: 1                  |Seq =3D=
 4236382324 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.829032|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236382325 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.845494|         ACK - Len: 9060               |Seq =3D=
 4236382324 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.845532|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236391384 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.861968|         ACK - Len: 1                  |Seq =3D=
 4236391384 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.862022|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236391385 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.878445|         ACK - Len: 1                  |Seq =3D=
 4236391385 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |
|2022-03-15 06:53:52.878529|         ACK       |                   |Seq =3D=
 502383551 Ack =3D 4236391386 |         |(57486)  ------------------>  (179=
)    |
|2022-03-15 06:53:52.895212|         ACK - Len: 1                  |Seq =3D=
 4236391386 Ack =3D 502383551 |         |(57486)  <------------------  (179=
)    |


There is no data in the recv-q or send-q at this point, yet the window stay=
s at size 1:

$ ss -o state established -ntepi '( dport =3D 179 or sport =3D 179 )' dst <=
Device B i/f addr>
Recv-Q Send-Q                 Local Address:Port                           =
     Peer Address:Port
0     0                  <Device A i/f addr>:57486                         =
      <Device B i/f addr>:179                ino:1170981660 sk:d9d <->


Thanks
-Erin

--

Juniper Business Use Only
