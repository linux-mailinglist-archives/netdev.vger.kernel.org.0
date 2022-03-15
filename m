Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD6D4DA6A5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 01:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244706AbiCPAHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 20:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiCPAHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 20:07:31 -0400
X-Greylist: delayed 898 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Mar 2022 17:06:18 PDT
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296355DA76
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 17:06:17 -0700 (PDT)
Received: from pps.filterd (m0209319.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FLfwV9000779;
        Tue, 15 Mar 2022 23:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=S1; bh=VcN4POBPtjKmkrS5BuJ/Kn9KWBbJnJ2Brg8zEnKL+bY=;
 b=aN4k/0ZOjLf2vDjedd/qZEZar+xKgOPzNZdz4dy7xHGH1ppJ+r8O7mlayZ+eM3xp0jFi
 5POTfOTkpVFG7VbO9YCj/FP29Z0yGoT2WWBv0xZOJYhJ3nDEF9yO/SkpBAA93Ymg/xhN
 R5He3xcHE6zJ+beda1bnUo2vR+9m+u1peH5Qynavggi6laoaQyXKoXPSGp6l2DvD6Vx3
 yOWQQ4YmSRFCVxIWusFOzzGW/9i9ofsAWIYjwv7fHoizLyGF06ylbEXlmbI+Xjbq7AmF
 bp9j25F2wQCPvJsP3v5FN5G2Z4RdnZ2Kyai4bQtKYdriHtWMVg1Gh0cX2MnZqdNl6r4g xg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3et65s9p2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 23:15:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUwyclmAfiqPgs2a5p9lpPaLNMEXDwscX+7KjlpCrsUc1r3Dy3QksALaU/dom339vpKJTK7XggaAJErBQiWMFVUXJUeeN4IaJdC+pj2qAyHbk1NkxQJwOOnqC4l6GP+2Y92xrKhWwGAt52PKSgQrpwbvwi3hKNQa5QRSPkaayksbRHt6dA8UIBY72KTUMQ34X+SuN1Kc5b8tnMo0i4Pzh8t0lhEdO7Ty4lKFI1iFNo/c3etKFnzfILndxVDWG9sga2bZkzmyMbedbGoqmfUzZwsvjQxHQFF5A4uUiWH3niJlwnht4XdJ++XDfFB9RrouS6whe8BGXdlWPUhQbdEOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcN4POBPtjKmkrS5BuJ/Kn9KWBbJnJ2Brg8zEnKL+bY=;
 b=ZPIruZ2R6x8Ore8zL47V5GXlcR6tou0P/6bb2En+/6YEGwlVcBWqviRO1kfOl9+KZFhTcdDEGWoMLWMuuzjFJTDUSt7IgpDDgKpBgSrPeic9hNKQEyAR4qSxSYjeqz8yYjCMDHDA4soFDquoIg9aKpiux4Mpqkibd2qELZegD+yFdKCHw2E6R+mcM0L7yWdDhdoZyuOg0O+w3qJP+h6+XL2p64+djS9vq5gzrSoj/HG/eUzSEVqXHCsfISxjfzxxR3WhdMoN+PD+uQdhJ8HwxufZ1SLb3L0oYbHptGv5uBq8/ox1jxckvJ+RM7uXU3dG03dvTmtdTxPklrgQHm8oiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BY5PR13MB3604.namprd13.prod.outlook.com (2603:10b6:a03:1a6::30)
 by BY5PR13MB3538.namprd13.prod.outlook.com (2603:10b6:a03:1a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 23:15:09 +0000
Received: from BY5PR13MB3604.namprd13.prod.outlook.com
 ([fe80::c855:73b4:572a:de28]) by BY5PR13MB3604.namprd13.prod.outlook.com
 ([fe80::c855:73b4:572a:de28%5]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 23:15:09 +0000
From:   "McLean, Patrick" <Patrick.Mclean@sony.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "U'ren, Aaron" <Aaron.U'ren@sony.com>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Intermittent performance regression related to ipset between 5.10 and
 5.15
Thread-Topic: Intermittent performance regression related to ipset between
 5.10 and 5.15
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9Q==
Date:   Tue, 15 Mar 2022 23:15:08 +0000
Message-ID: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 6a1e495c-312b-1ab3-b91c-0b4c8b143b27
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6804f505-fbf4-494a-d5b4-08da06d9a619
x-ms-traffictypediagnostic: BY5PR13MB3538:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BY5PR13MB3538F8585D81F44E99BD8F06EE109@BY5PR13MB3538.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yae8VW/br/wsQW6xiMbyPsLTAPB0d3y0YYCF6pOTvVj0UkJc22ogbCPZQak0hnfjl4OoAQauvgNBoVqWFvGELKcGZFNaN0xD942isf1Il7d15RKlwGKvSZkEaoUSYBllm4HjW+EFFvzY1awNBGX2uxzsRCSXiC5WqIj3ZwW/NyAZ14wgPUgKixLPijBRqBa6pmocoE2VO9OlZoKdZdvOjYuCe+f7NCeaEVzxFaCgHmFOf5wrZNf0hHLQP1PQxAs/BS61TlX7ak3+mYMZk3Sxs4lVKG9FCl+CTvEMfR0CAhYhlIH+4gkrKGjhm+XO4f1gs3XMxtCYJN8etTukV9v61HicN/nk6MhLM8uWAZxRRbtB5kOi0QX6dHM/v/gud4X+aZck4RPCV3cA7SIz2O8PGlCCIjTSgfgkr6XVap7i40zZ0fPCz0lna5NXR0+LnhKLGSzRuOTNcSg8SoAOBgVuMACPSVFRdxL8nNgBfzb3F0rwJlQpLoz46xahRhK5UCWR/zUXD1r1kzdhgZGe2ap3tn+SLJ1NunII/THmMWyPaKT6nzRoAxj+zvdwEOUHnpkOtUvF8Ws4/3kLRFR12d5gKqr2QVZobV7lKApZLW3LLAnA2yPNDnPwNuZfDr87PfVCuPjiWxq1wmz0p7zed+ZDitDXT0CwUQC3PrknIAg4nxEvsO0Hkbup6ANCmpPBQFul6q3oI+qzrpDaPznN70UUJ1h1mvGqPUmgPerzAJDPfj7eqR8/EHcqvy7IjwCcqdsy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR13MB3604.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(8936002)(66446008)(55016003)(5660300002)(66574015)(33656002)(54906003)(6916009)(64756008)(66946007)(66556008)(66476007)(76116006)(8676002)(450100002)(4326008)(83380400001)(316002)(82960400001)(9686003)(186003)(508600001)(71200400001)(38100700002)(7696005)(6506007)(2906002)(86362001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Yv0z1TFLfPLGtaDF6h0l19aoHOAnI6E1Nvho5aVixnBO/AQbtB9xRkU8?=
 =?Windows-1252?Q?5lS4jqyHo52oAGn9o1HTyk+OO/66M8EPOChPxb8f64SdPERkmGrAjUun?=
 =?Windows-1252?Q?RXlKacDa8Rcp+/YfmahgK/kEOkrAVZaOtk2DNU5YVJwm7TPvXo1Q5FF1?=
 =?Windows-1252?Q?Iq1ZN+IBdiIRC1jkCONcMcc5GHKSmbMKIRRz89rpxcHZaPbISXLhg1cn?=
 =?Windows-1252?Q?749Y3oDioDeRMqo0p5AyvM9d413jP25ZTljUlR3k33vGwnqwoUTImWFK?=
 =?Windows-1252?Q?xsJul91cJPPe7LmrhqZMBz8pohG0XEYIcT5tlytEa6yudostoJH6Ynbt?=
 =?Windows-1252?Q?rpeAoE0EZ8P/1TilA37mEeAXFvIT72FayTr7rsOZOde7kS79PdtXaBJx?=
 =?Windows-1252?Q?AdWT+6d/qDxKaiXwVWHKutxqClk146FnQmDK65YUhnCB5cF5XL5emMs1?=
 =?Windows-1252?Q?fLJGTvV+gN1JK/IIsjH7/hQttDREJsJ05+aAiObH1Co+GKOYNQ2Rz05Z?=
 =?Windows-1252?Q?OaeZwday4S3fAmNf0iXzQz1XXlKLqucPzas7a0dSbCH/0EL3Zvzf7XfZ?=
 =?Windows-1252?Q?NviY5vey6oYINv3vc3iT/jfmJ2ttcYmRPK2xvxJhalbNrbhn9sC9/eux?=
 =?Windows-1252?Q?Vc1rEf56uPGDPmwpA2Ol0UGz2Q9MXXLVLAKj++C346wQrCr0dRYclKPG?=
 =?Windows-1252?Q?lG4Ouw2mHcfhiZTeGNUbXOw4lXU1gJDvMbEE8pduWLjwgX9MOzuS4Or0?=
 =?Windows-1252?Q?LhD6DgND4bDp7/GapmjyUm3+mD+piDnElhTF9QtReFJrYtQf1mb/1qTZ?=
 =?Windows-1252?Q?v5GdmJmV65oBAL8k9F4HNKlU5+PFZNi2ayaN0PqUjbvxhvf735+xGQSL?=
 =?Windows-1252?Q?EugIbFuIFxNLVdkUSZF53FLMwkrc0iT9AkQjKVL9vopjBLWdZqShFnxS?=
 =?Windows-1252?Q?XVEzNi3/Z41Gqv/f3tXvBpq21d4VoEzxrgKvroqZQPC9IXbvAmdZYK8z?=
 =?Windows-1252?Q?EoNWsfDuZyIQD6zsZFtlwLYRyNzM7VNlH8TWWxmeYDZtepAYuRxjwoKh?=
 =?Windows-1252?Q?lGIwQLS5T0vUjMOHEXHzvZRSwnK3hwWAaoJAiQ1YLq8nCyq1T3tOeWJX?=
 =?Windows-1252?Q?x2eeQ4zmxDqXoxdcqu5/8crKPZ+TSK1BPVVOZB0PNwF4kBTGN7EY3/pB?=
 =?Windows-1252?Q?kNv/mJFOK93bBZVp74F/Pt4EslleVr/zitsLm83XLEDotFt/iHbckwQ8?=
 =?Windows-1252?Q?mmMcZK7dh5e5gArLaT92n8yp2rWHiiQoRcWInxwfK3SxQQFoolMAqe3c?=
 =?Windows-1252?Q?4MhnxZ88onnsW4GmxSLB4d33ttFUJbE4xfbZvH2Ri3lGVfGEyIyCuJla?=
 =?Windows-1252?Q?sGfy7qdYfzfK+9Q+ptbHNPf5mVWGJKLs6YQhQzV2c+Gy8wKQXGnFmI4b?=
 =?Windows-1252?Q?uS3ejWEVGN1Rvy8EPdIXNDO1cG06sykB5fTycHpIP4VWkWbQq+uONM/E?=
 =?Windows-1252?Q?uk75Wd71qiYsfid4h9VljiTmzczpuurxx7VVgFpj4QrYQi830dTgwsNM?=
 =?Windows-1252?Q?6WCsSqzMSBM3MrhFe3qwkgge8fBpHizKqpDxvj19v/R7V4F6ywXrxA8K?=
 =?Windows-1252?Q?cf9xcyN7cuTCjOIFwvpuV5DU?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR13MB3604.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6804f505-fbf4-494a-d5b4-08da06d9a619
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 23:15:08.8227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DiKJYJdp1p5F6IaonnlkMBqPIdHFj3is6aCV4PooLWFJL3EOvgscgYE1e+sfVrscg8/OYgzuiWAgf73khaXtcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3538
X-Proofpoint-ORIG-GUID: mC_jCS4H9Aa6NOa8_qMwCNpUbr2OZTpo
X-Proofpoint-GUID: mC_jCS4H9Aa6NOa8_qMwCNpUbr2OZTpo
X-Sony-Outbound-GUID: mC_jCS4H9Aa6NOa8_qMwCNpUbr2OZTpo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_11,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 mlxlogscore=441
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150137
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.16) serie=
s, we encountered an intermittent performance regression that appears to be=
 related to iptables / ipset. This regression was noticed on Kubernetes hos=
ts that run kube-router and experience a high amount of churn to both iptab=
les and ipsets. Specifically, when we run the nftables (iptables-1.8.7 / nf=
tables-1.0.0) iptables wrapper xtables-nft-multi on the 5.15 series kernel,=
 we end up getting extremely laggy response times when iptables attempts to=
 lookup information on the ipsets that are used in the iptables definition.=
 This issue isn=92t reproducible on all hosts. However, our experience has =
been that across a fleet of ~50 hosts we experienced this issue on ~40% of =
the hosts. When the problem evidences, the time that it takes to run unrest=
ricted iptables list commands like iptables -L or iptables-save gradually i=
ncreases over the course of about 1 - 2 hours. Growing from less than a sec=
ond to run, to taking sometimes over 2 minutes to run. After that 2 hour ma=
rk it seems to plateau and not grow any longer. Flushing tables or ipsets d=
oesn=92t seem to have any affect on the issue. However, rebooting the host =
does reset the issue. Occasionally, a machine that was evidencing the probl=
em may no longer evidence it after being rebooted.=0A=
=0A=
We did try to debug this to find a root cause, but ultimately ran short on =
time. We were not able to perform a set of bisects to hopefully narrow down=
 the issue as the problem isn=92t consistently reproducible. We were able t=
o get some straces where it appears that most of the time is spent on getso=
ckopt() operations. It appears that during iptables operations, it attempts=
 to do some work to resolve the ipsets that are linked to the iptables defi=
nitions (perhaps getting the names of the ipsets themselves?). Slowly that =
getsockopt request takes more and more time on affected hosts. Here is an e=
xample strace of the operation in question:=0A=
=0A=
0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=3DS_IFREG|0644=
, st_size=3D539, ...}, 0) =3D 0 <0.000017>=0A=
0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory) <0.000017>=0A=
0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) =3D 4 <0.00=
0013>=0A=
0.000034 newfstatat(4, "", {st_mode=3DS_IFREG|0644, st_size=3D6108, ...}, A=
T_EMPTY_PATH) =3D 0 <0.000009>=0A=
0.000032 lseek(4, 0, SEEK_SET)     =3D 0 <0.000008>=0A=
0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) =3D 4096 <0=
.000010>=0A=
0.000036 close(4)                  =3D 0 <0.000008>=0A=
0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) =3D 4096 <0=
.000028>=0A=
0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 4 <0.000015>=0A=
0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) =3D 0 <0.000008>=0A=
0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [8]) =
=3D 0 <0.000024>=0A=
0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE-DST=
-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.109384>=0A=
0.109456 close(4)                  =3D 0 <0.000022>=0A=
=0A=
On a host that is not evidencing the performance regression we normally see=
 that operation take ~ 0.00001 as opposed to 0.109384.Additionally, hosts t=
hat were evidencing the problem we also saw high lock times with `klockstat=
` (unfortunately at the time we did not know about or run echo "0" > /proc/=
sys/kernel/kptr_restrict to get the callers of the below commands).=0A=
=0A=
klockstat -i 5 -n 10 (on a host experiencing the problem)=0A=
Caller   Avg Hold  Count   Max hold Total hold=0A=
b'[unknown]'  118490772     83  179899470 9834734132=0A=
b'[unknown]'  118416941     83  179850047 9828606138=0A=
# or somewhere later while iptables -vnL was running:=0A=
Caller   Avg Hold  Count   Max hold Total hold=0A=
b'[unknown]'  496466236     46 17919955720 22837446860=0A=
b'[unknown]'  496391064     46 17919893843 22833988950=0A=
=0A=
klockstat -i 5 -n 10 (on a host not experiencing the problem)=0A=
Caller   Avg Hold  Count   Max hold Total hold=0A=
b'[unknown]'     120316   1510   85537797  181677885=0A=
b'[unknown]'    7119070     24   85527251  170857690=
