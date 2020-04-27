Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15821BA823
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgD0Pi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:38:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2712 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727946AbgD0Pi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:38:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RFasow006801;
        Mon, 27 Apr 2020 08:38:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : subject : to
 : cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=87G1lpU+HOIhi4FZYDHLiReYnISkOXdz6NOEXEnAmyk=;
 b=tTiwQZNrDu3UBdDqRwGt7sw7Zbm2gw8YyEZCdGSCTJ9mnZm5ijyWfRRGvnSPL6/vLvdq
 eRRFBgYr3a04RxHvU2to32//u4j3HB/GYMwhJBjR2IFaNW/Ij0cgdVdRGMqzH92uL+T3
 hRWoWvGliMzteRRwByYzAX8VUQYTUFyR1ZDJ4YN6GFfsXmgiFwg7TW6kZ5SQDV2fQpWZ
 LE5VQKQnYXP4gJi/XdPKY/NWSDpfSl9Y3Q3ru35ZjK6E5GaTNqcOm/wytF7ckKFbwmR6
 25Sw7FaHDzfqdEv7chloKI87JjtaKtJ86TUyEO4Rd6SXm+DjBxowkh3bDKk4bxMaRXW3 Cw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjq84wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 08:38:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Apr
 2020 08:38:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Apr 2020 08:38:25 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 7BDCD3F7040;
        Mon, 27 Apr 2020 08:38:23 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200424.182532.868703272847758939.davem@davemloft.net>
 <d02ab18b-11b4-163c-f376-79161f232f3e@marvell.com>
 <20200426.180505.1265322367122125261.davem@davemloft.net>
Message-ID: <e34bcab1-303e-a4bd-862c-125f254e93d3@marvell.com>
Date:   Mon, 27 Apr 2020 18:38:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200426.180505.1265322367122125261.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_12:2020-04-27,2020-04-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>
>>>> On Fri, 24 Apr 2020 10:27:20 +0300 Igor Russkikh wrote:
>>>>> +/* Start of HW byte packed interface declaration */
>>>>> +#pragma pack(push, 1)
>>>>
>>>> Does any structure here actually require packing?
>>>
>>> Yes, please use the packed attribute as an absolute _last_ resort.
>>
>> These are HW bit-mapped layout API, without packing compiler may screw
> up
>> alignments in some of these structures.
> 
> The compiler will not do that if you used fixed sized types properly.
> 
> Please remove __packed unless you can prove it matters.

Just double checked the layout without packed pragma, below is what pahole
diff gives just on one structure.

Compiler does obviously insert cache optimization holes without pragmas.
And since these structures are HW mapped API - this all will not work without
pack(1).

$ diff -u3 packed.txt packednon.txt

@@ -15073,51 +15074,48 @@
 		u32                rsvd:2;               /*   176:24  4 */
 		u32                echo_max_len:16;      /*   176: 8  4 */

-		/* Bitfield combined with next fields */
+		/* XXX 8 bits hole, try to pack */

-		u32                ipv4[8];              /*   179    32 */
-		/* --- cacheline 3 boundary (192 bytes) was 19 bytes ago --- */
-		u32                reserved[8];          /*   211    32 */
-	} ipv4_offload;                                  /*   176    67 */
+		u32                ipv4[8];              /*   180    32 */
+		/* --- cacheline 3 boundary (192 bytes) was 20 bytes ago --- */
+		u32                reserved[8];          /*   212    32 */
+	} ipv4_offload;                                  /*   176    68 */
 	struct {
-		u32                ns_responder:1;       /*   243:31  4 */
-		u32                echo_responder:1;     /*   243:30  4 */
-		u32                mld_client:1;         /*   243:29  4 */
-		u32                echo_truncate:1;      /*   243:28  4 */
-		u32                address_guard:1;      /*   243:27  4 */
-		u32                rsvd:3;               /*   243:24  4 */
-		u32                echo_max_len:16;      /*   243: 8  4 */
-
-		/* Bitfield combined with next fields */
-
-		u32                ipv6[16][4];          /*   246   256 */
-	} ipv6_offload;                                  /*   243   259 */
-	/* --- cacheline 7 boundary (448 bytes) was 54 bytes ago --- */
+		u32                ns_responder:1;       /*   244:31  4 */
+		u32                echo_responder:1;     /*   244:30  4 */
+		u32                mld_client:1;         /*   244:29  4 */
+		u32                echo_truncate:1;      /*   244:28  4 */
+		u32                address_guard:1;      /*   244:27  4 */
+		u32                rsvd:3;               /*   244:24  4 */
+		u32                echo_max_len:16;      /*   244: 8  4 */
+
+		/* XXX 8 bits hole, try to pack */
+
+		u32                ipv6[16][4];          /*   248   256 */
+	} ipv6_offload;                                  /*   244   260 */
+	/* --- cacheline 7 boundary (448 bytes) was 56 bytes ago --- */
 	struct {
-		u16                ports[16];            /*   502    32 */
-	} tcp_port_offload;                              /*   502    32 */
-	/* --- cacheline 8 boundary (512 bytes) was 22 bytes ago --- */
+		u16                ports[16];            /*   504    32 */
+	} tcp_port_offload;                              /*   504    32 */
+	/* --- cacheline 8 boundary (512 bytes) was 24 bytes ago --- */
 	struct {
-		u16                ports[16];            /*   534    32 */
-	} udp_port_offload;                              /*   534    32 */
-	struct ka4_offloads_s      ka4_offload;          /*   566   712 */
-	/* --- cacheline 19 boundary (1216 bytes) was 62 bytes ago --- */
-	struct ka6_offloads_s      ka6_offload;          /*  1278  1096 */
-	/* --- cacheline 37 boundary (2368 bytes) was 6 bytes ago --- */
+		u16                ports[16];            /*   536    32 */
+	} udp_port_offload;                              /*   536    32 */
+	struct ka4_offloads_s      ka4_offload;          /*   568   712 */
+	/* --- cacheline 20 boundary (1280 bytes) --- */
+	struct ka6_offloads_s      ka6_offload;          /*  1280  1096 */
+	/* --- cacheline 37 boundary (2368 bytes) was 8 bytes ago --- */
 	struct {
-		u32                rr_count;             /*  2374     4 */
-		u32                rr_buf_len;           /*  2378     4 */
-		u32                idx_offset;           /*  2382     4 */
-		u32                rr__offset;           /*  2386     4 */
-	} mdns;                                          /*  2374    16 */
-
-	/* Bitfield combined with next fields */
+		u32                rr_count;             /*  2376     4 */
+		u32                rr_buf_len;           /*  2380     4 */
+		u32                idx_offset;           /*  2384     4 */
+		u32                rr__offset;           /*  2388     4 */
+	} mdns;                                          /*  2376    16 */
+	u32                        reserve_fw_gap:16;    /*  2392:16  4 */

-	u32                        reserve_fw_gap:16;    /*  2388: 0  4 */
-
-	/* size: 2392, cachelines: 38, members: 9 */
+	/* size: 2396, cachelines: 38, members: 9 */
 	/* bit_padding: 16 bits */
-	/* last cacheline: 24 bytes */
+	/* last cacheline: 28 bytes */
 };


Regards,
  Igor
