Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5262B578766
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiGRQ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbiGRQ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:29:28 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50077.outbound.protection.outlook.com [40.107.5.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A8B6157;
        Mon, 18 Jul 2022 09:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jy2XadaJ/xmJ7kDzicK1+o50bR64pmBAPlXuzGYq1XSavJWlFo+p1031zGKZajhVNGVq7OHQ9JTbiH+EtVXV86LfAfB6kWeQVgsCNHPaIjFbOfPdkqwK9VsG5Aln+4LXEDaIR4iLmD5Kf7+UnK9URAFDM9A7XdGVxZW+IPWS6W2Kw75Z3Ze/i74z5h6imA9RXzr0lRXEKiD+mh1YvPSt6/gLZ6Jg3DNIyPe0CEDQJfI4SSpLMtpbfF4uQBa/ui4XLWD2/rL2cJ3uSsAa48kkKkuZaF/pYAo0JYLfcJsvIY4LAaj1Xa75vHFvD9+TolgM1M2LmAqUiNo2Bc4NKZLetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kb2TnuTpSSsFQteP202aipCYbsd4q1tJ/B8T6Im07eA=;
 b=nMhUi6Bk9ZDeD6WMJdRswy/Qz8CGCbOKtI4aZtYQcUo7EVr4bp/tvJgBr2iJ6Qn+kbZ7tbW9KqHKjvSOczVqY+gxTblAhNxLOx/kLOy9KsQvSlCTxotE5L162wStwngtALDNDWuGaIQbMQUnwcpSkvEQyCIBrHkGbPRKkzBeAGgQEregQztaoKatqcKd7+3khAdBWkz8R/UADWho6rbcBpz3jHXJhD7uFrnz3ZgHiCZ8RAiVFo0aBdsXs63Ydoi8HBYaaugFiegDdI+hGbqVtE96fdZQzg9aI0fQ06ZGe/e7K4FL1vyiAOw61yLqqc+fw/c6GZ3yRPPeGPsBN3kCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kb2TnuTpSSsFQteP202aipCYbsd4q1tJ/B8T6Im07eA=;
 b=12lOjKck01auQfDoeTabJzxi4XPtnN+zuQjMdE7esbh5PVEobWxSyQHQ3e6R56fXiZGIF4sLfft5Mox1XlNBhz0EAAHdZvZdwoN9Y3m1h6Gow3+2amrvo2ATTHhIsgZPFOwZG4rmEaokuanavcDig6NZWmClBkqYEQabzQzVMv/OHF/GhYQysJZ6YDdgHl8AwOg3nu1WYdxsY9CREpTKPTKL/AeOW7zd6bietK9gA1A1w5ds60Ncq75/h305tM4JihUEDzSCDuWzgJ56qFtCYvvo1PG7ktF92YZgrk2quJeNX8jUAk23dtV6dz5KvI/DIzP2PqojafaL7oNY/SfcnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5097.eurprd03.prod.outlook.com (2603:10a6:10:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:29:23 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:29:23 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com> <YtMc2qYWKRn2PxRY@lunn.ch>
 <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com> <YtNoW8bJdWPzX3Cq@lunn.ch>
Message-ID: <41d87b16-e0ea-5b29-6ecc-8e90f906d366@seco.com>
Date:   Mon, 18 Jul 2022 12:29:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtNoW8bJdWPzX3Cq@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:610:77::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8de6ed8c-e9ce-4d02-452a-08da68daac38
X-MS-TrafficTypeDiagnostic: DB7PR03MB5097:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4iJxobPy3rvA1NwdzMu/P0tFYIuiiqoq51cSQLED1zUp4dRAI3ew8AT5Li1JwYQ/O8+17fgmCwTRU5aLFyb+ci7OiwJAXXiuTLeuGzpz6VpHB5NyqP3zu/Zpk8zCwqSIhUFN+IpW9hHGOUrT0n6SR5Nvb0BOa/WIns5a3FjPJtSkb1UWJr9XZV8qXklaqI2g/9UrkkmRqCrBMLs3v4zTXw6lVlaVavUoUZf5FGp1EIkNUFvf5rAsis2AcSQ794FCo6GApNc6ywt5T/DX1vFJzCWY4EwpMrtHn1yN3C8Ly4p2WvsjY+aW29VSMt0TyeUBzXa89teDQFVTybpDp7SzhMiAwcT5Rwk0vDAb8pFZJgveCtvNF7QgCAhVgmGjHF13svEBbLp9SY8DnLi0LOMu/yXJvG2khZVGCkNtzopIX8TUx+u2XFJ75SDQichtVRRe9ZyS2MqIYvGVIKoUeIjE1pj7AlAbLmLiTy2wn0fmBX6bBKRpfPF9a83KubVHmMsEV91lUAXD643Ddk8h0QN0SAeryD7LDKdmDsVVVonUz1a0yXJj/1TE+iE5IcmRtvemdeHCY2xoA2CLa4GFzDZ+oBiB0hhuSIjwZj2BUzO9CbFiqSB+3y+Ds3nnxjwEfuy4Sk7UTxwZHBrnpZgoJzVBFyvhfHDznBMqQOG/yevlbWYZ9nB62j+S2eQ4JYSi/jXUZgLHdy8ETaksC3isuy9CacxWWN0yLrdPcEwEjvzvOhtLofkmyRNDujOtVg0sKqn1ltEyvU9bFUgKO3DE0i3hlawnP2b79EE+CgBFv2EsNYfeSAx76/palKx7623ZDXvG8gFWji2TPQNo0OHW/VMNrpqTeb+jTkxQL1eTy6vSfmHOpeaXCvyC7FmMQKwCutRr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(4326008)(66476007)(66556008)(66946007)(8676002)(8936002)(6916009)(86362001)(316002)(54906003)(31696002)(7416002)(2906002)(31686004)(38100700002)(38350700002)(36756003)(83380400001)(478600001)(26005)(53546011)(41300700001)(6666004)(52116002)(6506007)(6486002)(6512007)(44832011)(2616005)(5660300002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjM5aGgwck1CY1R1a1BFSFNKWFJuWXp3RHUzQTRwa015bUpQVzlFNnNjSElQ?=
 =?utf-8?B?MUxoV3BLaVNRQXFGbXdveEJIUU1rYmhYRkQrQmY0Y0hFUW02TXNDZ0lFWTZw?=
 =?utf-8?B?RmF4WDNsQVN2UVhqS0pLK3o0aXVkaUhZUzRONGJrZXpyTHRCMHdjOHAxeG1J?=
 =?utf-8?B?R041OXFTWHF6ekZuNUwyUnYyYkhEc28xLy9WT2pjMU9FYWl4SytmZk9zOGt4?=
 =?utf-8?B?YU9ZcDRiWDFGMEN5dXN6bXp0T3gwOWgweUlwT1FPbGNobWlLc3FTY1FYb29a?=
 =?utf-8?B?WjhSNk4vQzNJS0tTUE1uNWNxUEZXOXMrYWZoSWRBV0wyWkl5d0ZpYmpmS0NE?=
 =?utf-8?B?ODlJY3U1Rml4Rkk4M3pzSExrdDFIdnpSejBKWkVpQVFkUW5UWndlUDZnRnFV?=
 =?utf-8?B?SlhKWGRKdXpmT1prL2lZL2NBRy8wUENsaTlGanRpVjZJQ05kOVplWDdUZllQ?=
 =?utf-8?B?TkpQcWxocnBGaG9PRW9Fd1JqYWt4QnF0anVPcGNuOTFaSzdDeFluVThYckdF?=
 =?utf-8?B?WUo0eTFNVUF3cSt5NUZoSVlXU0RYb0RRU25Oa1F2bFd5WEZYUEpoNVBCV2ts?=
 =?utf-8?B?emgyQVhoUXArQ0JucEp1REVqcWc5TzMzdzVUT2UrNjJ0VnIvWDBrL3p3OWhr?=
 =?utf-8?B?Q0pod2VoNmFOTjR5YVNBYXgrbFBOZTh0cGJWMjhOaXZrQlRheDhJNHVZWERm?=
 =?utf-8?B?L05od2ZmN0lqWVltSm9EQ1I5a0w0ckxEQkZiTHRpWFp3Nm1Jb2tYdVJiWjlK?=
 =?utf-8?B?ZnkzN1FWb09tNHpaVmdweTkzK2JTeVI3ajRydnkycXRsekxYcFh5ME04RWgv?=
 =?utf-8?B?MkZ2OWJxZWdOWHB1MVZYazZPVmpZVjBXc3kxb1VtMkpWNmQ5RTBQYjhFRFJM?=
 =?utf-8?B?aEc5QTlBbmtMc0QyM1JXaUJVYVZEUmdZalRPTHFFc05QWmk4RjE5YmZsUTVE?=
 =?utf-8?B?Q2YxazRxdWEwZ05GdWRQZUxNSVNEL0NZNC8vUjEzZEJvMGh5RUlkakFJcEUz?=
 =?utf-8?B?a29Hd0tHNXVROGRrTWpuSjhPWWRsWWZ6cVhZdW9WVTJkd3IyL3JuTkJYaExv?=
 =?utf-8?B?Ri9iNVY2VC95TmpvQ3FpeGM5ZTBkT3ErdW5WUU1GWGg3U1llVTE0enN6NzYr?=
 =?utf-8?B?VFVIYStZM3NrbmlSUUxuS1pTeThyV3p5M0wyTmNLc21pWlB4ZWhPWkRSN0lH?=
 =?utf-8?B?Zk55U0VLRG5ZVUo0T2lVQkNGWFd3UWszLzFVYzBnMFo4ZDlaNXdBL3g4cThz?=
 =?utf-8?B?L1ZuUjJPRVN5N2laSDBIdHVVcXNrS0NBU1RWUVFVT1R4dGFJTGFZaVhucFhP?=
 =?utf-8?B?enBST3YrVjZ2R3hxampsZHFTUHBKL2pyczRtc2xMcHhwd1BNbUZHd1ZpNDhB?=
 =?utf-8?B?enhHMGN0VGY2T0Ryd1ArKzA5UGVrUHI4SXIwbUY4N1JId2ZqdjZNeFpKSHBN?=
 =?utf-8?B?dEREZG1CNXMzUkxtdjNlSGhvUXhvS2pNVjA1OW96RWdoMmltSDAxSVdlTGNR?=
 =?utf-8?B?MXRrNzhPaEpPejZMSzhSMkRFYk9TU3BCVWV2ZlYzTGtwOTM3RW5KWjlSeitX?=
 =?utf-8?B?VXBhUTlwd3VjOXlLUE91Z01tb0pxZ3lRT0cyRUYzQWJwWGo2NWsxcER3QVgz?=
 =?utf-8?B?czAzSEVqcjVVa1JUQlQyL3RYc2NXRTBVd3p3bi9EYW9QRHN1RVhGMlVFQ0tZ?=
 =?utf-8?B?Mm8vK0dOMmNOa2toMG5vTFN6SnF4UUwwL3F3MzVMU2tBQjc2R0RQYVFwTUFn?=
 =?utf-8?B?QzVlZ1NOWlU3ZXJIYktuaUtmZlhKVnBlVFh0NG40MXhpTDJzUFJkbzJyTGt3?=
 =?utf-8?B?MFNoT21yTlRtVGhDeXp3Y0hCNFoxOVJadGxGM2d3UXlyREE3K2hJN3FONkdt?=
 =?utf-8?B?OVNZbkxDQ1EwbWhGUXUxT2p3U1FmVmJkYXN2MmIrZmg3LzErU3hCblRNNXBX?=
 =?utf-8?B?RDErMHR4a2JzN3UrM28zNjlDYWx5U3VJa1VEZkoxRkI3a0Y3MXJkR2tNWEVR?=
 =?utf-8?B?M21sVmsxZWVVaGwxUEtBclU5cnc4Mys0cVBaWmdvOVpBQjlDL2ZabWhDMWNW?=
 =?utf-8?B?NUtncXBCeGVFZko2cDRaTFY1UCt0S2VoQndrYU1QM3RjUUxabS8wVzh2ck5s?=
 =?utf-8?B?ZWxRblNYT0lUWFY1aExOQ0VLRWJGU0FVTS8wYWxYbmVlM3gwQ1lycGg1MG1q?=
 =?utf-8?B?R0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de6ed8c-e9ce-4d02-452a-08da68daac38
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 16:29:23.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4CWhPj+7SLelQi03mj2U918v5GbPQsz/Q5+dxIxYos2W4nNHIv3lMeL3FevfoYCM7ifFORwYqfM7YZHmdlYEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5097
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/22 9:39 PM, Andrew Lunn wrote:
>> > I would not do this. If the requirements for rate adaptation are not
>> > fulfilled, you should turn off rate adaptation.
>> > 
>> > A MAC which knows rate adaptation is going on can help out, by not
>> > advertising 10Half, 100Half etc. Autoneg will then fail for modes
>> > where rate adaptation does not work.
>> 
>> OK, so maybe it is better to phylink_warn here. Something along the
>> lines of "phy using pause-based rate adaptation, but duplex is %s".
> 
> You say 1/2 duplex simply does not work with rate adaptation.

It doesn't work with pause-based rate adaptation. This is because we can't
enable pause frames in half duplex (see phy_get_pause). I don't know if this
is a technical limitation (or something else), but presumably there exists a
MAC out there which can't enable pause frames unless it's in full-duplex mode.

> So i
> would actually return -EINVAL at the point the MAC indicates what
> modes it supports if there is a 1/2 duplex mode in the list.

Well, half duplex is still valid if we are at the full line rate. This is more
of a sanity check on what we get back from the phy. That is, we should never
get anything but full duplex if the phy indicates that pause-based rate
adaptation is being performed. So maybe this should live in phy_read_status?

And of course, CRS-based adaptation requires half-duplex (or a MAC which
respects CRS in full-duplex mode).

>> 
>> > The MAC should also be declaring what sort of pause it supports, so
>> > disable rate adaptation if it does not have async pause.
>> 
>> That's what we do in the previous patch.
>> 
>> The problem is that rx_pause and tx_pause are resolved based on our
>> advertisement and the link partner's advertisement. However, the link
>> partner may not support pause frames at all. In that case, we will get
>> rx_pause and tx_pause as false. However, we still want to enable rx_pause,
>> because we know that the phy will be emitting pause frames. And of course
>> the user can always force disable pause frames anyway through ethtool.
> 
> Right, so we need a table somewhere in the documentation listing the
> different combinations and what should happen.

OK, so first here's table 28B-3 (e.g. linkmode_resolve_pause):

Local device  Link partner  Local resolution Partner resolution
============= ============= ================ ==================
PAUSE ASM_DIR PAUSE ASM_DIR Transmit Receive Transmit   Receive
===== ======= ===== ======= ======== ======= ========   =======
    0       0     X       X        N       N        N         N
    0       1     0       X        N       N        N         N
    0       1     1       0        N       N        N         N
    0       1     1       1        Y       N        N         Y
    1       0     0       X        N       N        N         N
    1       X     1       X        Y       Y        Y         Y
    1       1     0       0        N       N        N         N
    1       1     0       1        N       Y        Y         N

And now here's the same table, but assuming that we have a local phy
performing rate adaptation

Local device  Link partner  Local resolution Partner resolution
============= ============= ================ ==================
PAUSE ASM_DIR PAUSE ASM_DIR Transmit Receive Transmit   Receive
===== ======= ===== ======= ======== ======= ========   =======
    0       0     X       X        N       N        N         N # Broken
    0       1     0       X        N       N        N         N # Broken
    0       1     1       0        N       N        N         N # Broken
    0       1     1       1        Y       N        N         Y # Broken
    1       0     0       X        ?       ?        N         N # Semi-broken
    1       X     1       X        Y       Y        Y         Y
    1       1     0       0        N       Y        N         N
    1       1     0       1        N       Y        Y         N

The rows marked as "Broken" don't have local receive pause enabled.
These should never occur, since we can detect that the local MAC doesn't
support pause reception and disable advertisement of pause-based
rate-adapted modes.

On the row marked as "Semi-broken", the local MAC supports only
symmetric pause, and the link partner doesn't support pause. We're not
supposed to send pause frames, so we disable pause, but this breaks rate
adaptation. In this case, we could renegotiate with rate-adapted modes
disabled. Alternatively, we could just decline to advertise rate-adapted
modes for symmetric-pause MACs. This avoids the semi-broken line above,
but also prevents the line below from using rate adaptation.

> If the MAC does not support rx_pause, rate adaptation is turned off.
>> If the negotiation results in no rx_pause, force it on anyway with
> Pause based adaptation. If ethtool turns pause off, turn off rate
> adaptation.
> 
> Does 802.3 say anything about this?

Only IPG-based and CRS-based rate adaptation are defined in 802.3.

> We might also want to add an additional state to the ethtool get for
> pause, to indicate rx_pause is enabled because of rate adaptation, not
> because of autoneg.

Probably a good idea.

--Sean
