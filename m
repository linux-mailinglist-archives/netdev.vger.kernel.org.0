Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6716E5919
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDRGIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRGIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:08:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC53468E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 23:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681798087; x=1713334087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jZd967WN7ppNIsQ78lhpWFyZRL3ypnT5Ghkvyq79brA=;
  b=JORXJRdC/8iMNlNMlysrye6/a7wZw2SjUzI/bFQON8I3IdO7ZP6WgAH/
   TOGLH2EUWTzRWppgaaLOrY13bI0y5Qy4ZzV/thurb11MVF5jSgtlLwV6j
   ga5V4htdzlJkGXcpO3Zm/zBFrnJsRvken41rrZuPzxCiqiqa9dp0zEw84
   htHtf/Bh2p2UZRVLGZyI3oafwECB2M6N9BVm9Yee4CeO5BP74C+YAq7Ka
   CMGEMjmm+xkAbnQ1lNDtBTwWR8fyjfjlZduv9HDm+DzFd11ekSE5AJJfW
   xm8wtqsNPnNey5+Rq+iEVPjAiupyZ5xsQTuVnGgD301ryQJvpPXzxrPtX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="333885931"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="333885931"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 23:08:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="815081725"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="815081725"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 17 Apr 2023 23:08:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 23:08:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 23:08:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 23:08:05 -0700
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by DM8PR11MB5607.namprd11.prod.outlook.com (2603:10b6:8:28::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 06:07:58 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 06:07:58 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>,
        "Brouer, Jesper" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Stanislav Fomichev" <sdf@google.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH bpf-next V1 5/5] selftests/bpf: xdp_hw_metadata track more
 timestamps
Thread-Topic: [PATCH bpf-next V1 5/5] selftests/bpf: xdp_hw_metadata track
 more timestamps
Thread-Index: AQHZcTz1X0h8VE1O+0qh5RVifeCknq8voQQAgADy+XA=
Date:   Tue, 18 Apr 2023 06:07:58 +0000
Message-ID: <PH0PR11MB5830D771AA05F28675173A42D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174344813.593471.4026230439937368990.stgit@firesoul>
 <87leiqsexd.fsf@kurt>
In-Reply-To: <87leiqsexd.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|DM8PR11MB5607:EE_
x-ms-office365-filtering-correlation-id: 4b42bdbe-421e-45dc-6675-08db3fd34255
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9PFiGaRR8y9JSE2iLGEpDOMhS82J6aycMDMAsRKkYJayRqndG5Z4DjFpnxFKc/YEwfCf6fFI+Y+2fCsiQlk2q7zOkOeZr/Xs7apm/BdiViM9P8wQLKYI50m+L5RoZ7TD8a2AFJ2C2zYvk/1zPRvg0m37mxW1qGSlrhmaTD7LKeFeRe+QSQkKlFL8+kJyZ7RK2IlAiabh6GZqwaSHfk2xXw2KInKZ8GTKLMJ4Q381qkJIxZARBF2LJhD0hty/n8rMZ98qYH9D5XaP42byp+xmVEcJbHi6cHM7ijwB6DuXv2WtI7hnk0kkpMjpnTZiIdCeZjvj+KXNhNmmvRIjoyH9x3/646E5LJN06m0RdBGeGC9GLGhZo8U3v7IsnCVSNuELQweWVD64O3/XQFHFA6+r9twf8ie+pyGMt/G2ZRLkZEXVmWLDqNlqo69w8oelybKdCZ8h5f6Ay2QpB3rYGVGl2Xh/CtqN2m1Q94LOl68Qpg6crqkXyH8TeLQhh1GGgfCduVkzNVs/RoVJh90DyMAsQwGaCB6jLcAIgsGt3t8O8+qJ2pFli3NxTEf8s7VOfn2T1MhJqpvtZFf8Cs5b3Y53VoF+WF8ZOXOFRPnk0w2tzww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(38100700002)(8936002)(8676002)(122000001)(38070700005)(5660300002)(7416002)(2906002)(33656002)(86362001)(52536014)(55016003)(478600001)(7696005)(71200400001)(54906003)(110136005)(186003)(966005)(9686003)(66946007)(53546011)(55236004)(6506007)(76116006)(66476007)(66446008)(26005)(41300700001)(82960400001)(316002)(83380400001)(4326008)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?eBOVCNGQ91RtGoGR1j5mXN3drEBYf5ADwC4a2Vp9vLE3byAYV1jX6uxrKB?=
 =?iso-8859-1?Q?FYE588YpF1qASEDS65DgGog+rxvak2HnpJyDlpKEYu2HnN6XuckFVls7YF?=
 =?iso-8859-1?Q?eSt3sLN6SQ41KjOy7aZLWYoXCVuSIfd6Ga8Xi0ABp/LNagE/mZbkQcwdPk?=
 =?iso-8859-1?Q?f3VgCA43wNUt7K38LYUA9mp4WJcGimmYif+UXR2wiItJ4vcj9AORbcbzfi?=
 =?iso-8859-1?Q?YOuCAajavxiWzpRLfDp46YfeZDzKmjUc8FCPdJEDBDl7AjjPqAre5g1Lu1?=
 =?iso-8859-1?Q?3vDDUl11enqFbnE65DFQslF9mAXsM2WX1oiVAuoEdeV5nGjjMvVoB/fpxZ?=
 =?iso-8859-1?Q?Mr3ZhoWYBuLRE6/Iz8o+SUKX5JwYtQqg9c4PMrLw3+a6sqp+ApNjVy8FrD?=
 =?iso-8859-1?Q?iwyIO1iM7NZgOz2VRFccuhUppPjuVS22Uw6iz9vRT5mPFCIgxfj4k0sm+t?=
 =?iso-8859-1?Q?t8Npv1OjVeoPPt+J6fC4z8rpM96G6iooI/RTeyhy2c7/rKW3l8Dry2JUl3?=
 =?iso-8859-1?Q?CdMz8SVHxk52z7L8owsLAlOf2sS6E8UKS+6pN/UJJBvl8ixoGgzAjHG7C2?=
 =?iso-8859-1?Q?94d4GOmHGIwWuxWdSB3l6vpPAZeTsdfg0ZiEB3R21QWqWI3/EAqzPBfAH6?=
 =?iso-8859-1?Q?TrgSlMADU2PfiQVfwXCyluqbxdgc+zNBU7CGk/lLSUht3qFJJ+mGigeBLM?=
 =?iso-8859-1?Q?M8/eddAqXIXK+5CTCqhGz+MK7pmFKQhQnwMjBOjxbWhZkHAS722MJVBkEw?=
 =?iso-8859-1?Q?XYoPrC0Swncppu5uB6bz8oXMra0NtaKB5JLjKRJfQVC1X46PBBv4z2q18t?=
 =?iso-8859-1?Q?fjs9Hh/aUtHWKAref0d1AbHhYi5etbmara/kHIZGnOI3S4/VGI48cUIyTr?=
 =?iso-8859-1?Q?fZYI62QsdRIcLH2Dt5h3kINchzQRRMVJAhXkIQSNfz9ayP9UzbUJZAqqRd?=
 =?iso-8859-1?Q?4PQKQKcHFevi0S2UmrOWTW2YdJ6MrpjBINycfyOXupt0FXcTYokubia94x?=
 =?iso-8859-1?Q?fIlNUgOvADJtANpMD7EhGXRYqkfBCOAtRa51BkEUser09ZnthAJrNQFwDa?=
 =?iso-8859-1?Q?36Ez7r+80DfE/L3jvEB/nxgFbPfgXGXK3PvdLx6ogJaw6a8G3Hgt2NRfCZ?=
 =?iso-8859-1?Q?Op0IqMmeYzgOG/2WQz2TMAcTn4bRvzCcxQlzBUBb19VXVbMrilDSzChs5Y?=
 =?iso-8859-1?Q?pesL7jKDZAD/kphUtJk1Z6GG/FC/0j4qtVUwbvcOtukiTXRCAwZzud1Tow?=
 =?iso-8859-1?Q?6gLHUPspi/W7qUmEhpaTprJuzEszWrghcJ3xiDQh6rDBsfnovsQspbTIfh?=
 =?iso-8859-1?Q?pGgJrf77ViSAJf0YELZ8czwvIjm7EQD77uJZVUzADD4m18uPxE7BX3XMXm?=
 =?iso-8859-1?Q?5ch8Gboa9SJdzRNBa9oDYpSIbHQOS3ULyL3bUgjaALSUP30HGVIkJisiJr?=
 =?iso-8859-1?Q?6j0dsiOl1K69jLcXnSdR3t8GgVqdGp2fghUWDErBCvJ/FV6YeRJmSiUbjk?=
 =?iso-8859-1?Q?5Hgs8BPNc64RorKcx3z3ufKGRY5fVHcMXd8CXTsle378+TRIRXCQPezXl2?=
 =?iso-8859-1?Q?u/MXqF96tVKHpBbaewN8w1fmSDUEC4T22QtGz6EiQy3eRljMZtGnF1jW+T?=
 =?iso-8859-1?Q?tOj7M6M7UEz5sE/hQ9ZjErVpn9E878kVUmrcYejWAZU4i0kbEW5QZswQ?=
 =?iso-8859-1?Q?=3D=3D?=
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzvlrPQigRTTRoAv8BJqUrik7u/R6FMVYJjaFSdEK1XCP3LCZDAC000vqVAagIV1hovGX3ZaoJJBTEnyO2dTJkMxpija1ChA4UCOuto0PSHUZlAkP2eaMro0yhZd+EBPIPfjzs84SQ/Yab9x1D9Mmojq1/K7NUhmaTDpu3kCfagx/zSNf0Ay5gJXynfk2ZJAWkXycp49IA7UGVL+UeVKqoWSJweSGlLWS1IGNg4cxhdVOdJ0KsRTWa/+vVxgEKJG5DwtwGeenO196S87YewvSYlbKARn5qJJRTzGo81lUInrFwdF9TajNo7d3vRxdIOwnb08BEaQPi6zmaHCIWUPhA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqxcDutCaKo35fgeNsRQBC0OoE1BsEXVgTPOPKtRAJk=;
 b=ltTR7Ee02YQClHxUFrJVZsP6RsHt5KTeF0MFC8Utk90gTKk5y7oNLQY0kp70hJQcS8DX0vhN5TovOTmwNRQo3rpD6pxTkBajHOwfcxyHQ2RW80lcC8RMyMaZ29PA72VcFABbQs7dvgN/VhnSdeKYy40IK8sNW+bp5eYACTsmnBcPJCoHX/J2iUSieQHLncHzJmXP+l39nR87QOSB3yD/bOXKrHGSyf0x1vFk/+E0YPxlsqo7ki9DuqK/6ShlvavLFUyHLD+b67SomlI59sGzhbLqEeSBcFnY0ncG7T6mRqMYK6sv8Mrz9pWqzD96F/HqlUd9QshE9wLLL+GsKjTi9w==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: PH0PR11MB5830.namprd11.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 4b42bdbe-421e-45dc-6675-08db3fd34255
x-ms-exchange-crosstenant-originalarrivaltime: 18 Apr 2023 06:07:58.6009 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: yv33mAaZ+o+H1Ue2u2+UknwSxGMt+2GRFKsox1cGe8t5/+sARTbkQ0ZCMGsewS7kbanIkXx+ftr8E0t0IgOh6a6oGt3bfTdGV5sSWn9q/Ps=
x-ms-exchange-transport-crosstenantheadersstamped: DM8PR11MB5607
x-originatororg: intel.com
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, April 17, 2023 11:32 PM, Kurt Kanzenbach <kurt.kanzenbach@linutr=
onix.de> wrote:
>On Mon Apr 17 2023, Jesper Dangaard Brouer wrote:
>> To correlate the hardware RX timestamp with something, add tracking of
>> two software timestamps both clock source CLOCK_TAI (see description
>> in man clock_gettime(2)).
>>
>> XDP metadata is extended with xdp_timestamp for capturing when XDP
>> received the packet. Populated with BPF helper bpf_ktime_get_tai_ns().
>> I could not find a BPF helper for getting CLOCK_REALTIME, which would
>> have been preferred. In userspace when AF_XDP sees the packet another
>> software timestamp is recorded via clock_gettime() also clock source
>> CLOCK_TAI.
>>
>> Example output shortly after loading igc driver:
>>
>>   poll: 1 (0) skip=3D1 fail=3D0 redir=3D2
>>   xsk_ring_cons__peek: 1
>>   0x12557a8: rx_desc[1]->addr=3D100000000009000 addr=3D9100 comp_addr=3D=
9000
>>   rx_hash: 0x82A96531 with RSS type:0x1
>>   rx_timestamp:  1681740540304898909 (sec:1681740540.3049)
>>   XDP RX-time:   1681740577304958316 (sec:1681740577.3050) delta
>sec:37.0001 (37000059.407 usec)
>>   AF_XDP time:   1681740577305051315 (sec:1681740577.3051) delta
>sec:0.0001 (92.999 usec)
>>   0x12557a8: complete idx=3D9 addr=3D9000
>>
>> The first observation is that the 37 sec difference between RX HW vs
>> XDP timestamps, which indicate hardware is likely clock source
>> CLOCK_REALTIME, because (as of this writing) CLOCK_TAI is initialised
>> with a 37 sec offset.
>
>Maybe I'm missing something here, but in order to compare the hardware wit=
h
>software timestamps (e.g., by using bpf_ktime_get_tai_ns()) the time sourc=
es
>have to be synchronized by using something like phc2sys. That should make =
them
>comparable within reasonable range (nanoseconds).
>
>Thanks,
>Kurt

Tested-by: Song Yoong Siang <yoong.siang.song@intel.com>

I tested this patchset by using I226-LM (rev 04) NIC on Tiger Lake Platform=
.
I use testptp selftest tool to make sure PHC is almost same as system clock=
.
Below are the detail of test steps and result.

1. Run xdp_hw_metadata tool.
   @DUT: sudo ./xdp_hw_metadata eth0

2. Enable Rx HWTS for all incoming packets. Note: This step is not needed i=
f
   https://lore.kernel.org/all/20230414154902.2950535-1-yoong.siang.song@in=
tel.com/
   bug fix patch is applied to the igc driver.
   @DUT: sudo hwstamp_ctl -i eth0 -r 1

3. Set the ptp clock time from the system time using testptp tool.
   @DUT: sudo ./testptp -d /dev/ptp0 -s

4. Send UDP packet with 9091 port from link partner immediately after step =
3.
   @LinkPartner: echo -n xdp | nc -u -q1 <Destination IPv4 addr> 9091

Result:
   poll: 1 (0) skip=3D1 fail=3D0 redir=3D1
   xsk_ring_cons__peek: 1
   0x5626248d16d0: rx_desc[0]->addr=3D100000000008000 addr=3D8100 comp_addr=
=3D8000
   rx_hash: 0x35E1B60E with RSS type:0x1
   rx_timestamp:  1677762195217129600 (sec:1677762195.2171)
   XDP RX-time:   1677762195217202099 (sec:1677762195.2172) delta sec:0.000=
1 (72.499 usec)
   AF_XDP time:   1677762195217231775 (sec:1677762195.2172) delta sec:0.000=
0 (29.676 usec)
   0x5626248d16d0: complete idx=3D8 addr=3D8000


