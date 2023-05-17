Return-Path: <netdev+bounces-3449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 940177072C1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EFF21C20F30
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCE7449A3;
	Wed, 17 May 2023 20:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6356111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:10:26 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4305659B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 13:10:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HD23SH027009;
	Wed, 17 May 2023 13:10:15 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qmnba4ba6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 May 2023 13:10:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJ9jghKnU2Am2FYK1dmpEZ0dQFSS17yX5QZx3whmoPjSM7YCC2y02U/Uj6g8jElAmnd5FQUBzTqPsYSi/O59OSsCGtCTzaFhFQTIXos5YGvhNUrHZfVz9u/ndZC+jwVscNXbi6oMv2F3+L3jHwiFS6iZNd903TGV65VDtY2qxb/XnggZ7dn+51k/fR5+EK9NtrReij134YXjJO1yiIqEQgDsWKOpR5cMt5XajRt69B21JgOdSjPdShcCAAcsiGycN7QHjBU2gOibON/QU13h4hIN40K1HYADYyKJ0zZks47ofDcaT9VRhrG3RHWjNHTlmuKeB+oOoBVnZ5OXlWDoyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/55R6b8GIu6UZat5C0HmjuGzk7+FBtlLfczbw/uJLY=;
 b=WLI7T/SYDZPLQF0GRsrvAJA/HYvLTkuhLwJYCrG4t1DqD35CRFL2HFeXMeXT4hY1irjQKosy2InI433gVEUkA/dRGo6scG9Y7si6mT9lfcRFgXmSPgWH6SAJ0wWpumXh+diy6n5TzZecty/zFcCA+a1simue/8vgCp2trOEOwRHQLGgRn1rpF9UFKPDaUBXS54lbdmhMy4fjne0ot0V2fhYv4bzWmzckNRcmFsEaz6MRU1jjMlTgrrVH/382/tcmje83+cdDkhEfnyrO7pAzAZwun2/1+JGjKL/RVEGv2YAehqHdDV21qUw/LHR0Vy8Oj4zFbupVED43RcOykEHlbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/55R6b8GIu6UZat5C0HmjuGzk7+FBtlLfczbw/uJLY=;
 b=EnzBIYkaYHEB3EJxMgrdrzze3FL/apwfG9NA2CyuDLJBA6TPyXWqeOA1NDS/yf2AeVJALmbZu0vH4JhvpsTPvknjja/8evtrPV9+WN9h7GJb4CN5PYBw53wSoH93pEq7tjrq0KJfrrerGSPz1FsggZF24IXoFUUPkdAMuc6Gpm0=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BY5PR18MB3362.namprd18.prod.outlook.com (2603:10b6:a03:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 20:10:12 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a%6]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 20:10:12 +0000
From: Manish Chopra <manishc@marvell.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>, Alok Prasad
	<palok@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S
 . Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH v3 net] qed/qede: Fix scheduling while atomic
Thread-Topic: [EXT] Re: [PATCH v3 net] qed/qede: Fix scheduling while atomic
Thread-Index: AQHZeex3wjg7rfWZeE6bx4cvyrwzZK9A+WOAgAbqVYCAFx6wEA==
Date: Wed, 17 May 2023 20:10:11 +0000
Message-ID: 
 <BY3PR18MB4612227EE7818D9FDFA4BE4DAB7E9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20230428161337.8485-1-manishc@marvell.com>
	<20230428102651.01215795@hermes.local> <20230502200307.11bbe4ef@kernel.org>
In-Reply-To: <20230502200307.11bbe4ef@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWFuaXNoY1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWQyMTcyNjlhLWY0ZWUtMTFlZC1iNmQ5LWQ4Zjg4?=
 =?us-ascii?Q?MzVmNjc2YVxhbWUtdGVzdFxkMjE3MjY5Yy1mNGVlLTExZWQtYjZkOS1kOGY4?=
 =?us-ascii?Q?ODM1ZjY3NmFib2R5LnR4dCIgc3o9IjE2NDIiIHQ9IjEzMzI4ODI3ODA5MjYz?=
 =?us-ascii?Q?NzE0MiIgaD0iWVpNb1h6TUtmdFR1TlUrb21BcEQ5eTRseldBPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBTWdNQUFE?=
 =?us-ascii?Q?V1kyK1UrNGpaQVk5MmlySTMwMXZGajNhS3NqZlRXOFVVQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQllEQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFFQkFBQUE0K1V0REFDQUFRQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFDUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFjZ0JsQUhNQWRBQnlBR2tBWXdCMEFHVUFaQUJm?=
 =?us-ascii?Q?QUdFQWJBQnZBRzRBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1B?=
 =?us-ascii?Q?WHdCeUFHVUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFhQUJsQUhnQVl3QnZB?=
 =?us-ascii?Q?R1FBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0Jo?=
 =?us-ascii?Q?QUhJQWJRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpB?=
 =?us-ascii?Q?SFFBWHdCakFHOEFaQUJsQUhNQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJ?=
 =?us-ascii?Q?QUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFHOEFhZ0Js?=
 =?us-ascii?Q?QUdNQWRBQmZBR01BYndCa0FHVUFjd0JmQUdRQWFRQmpBSFFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBB?=
 =?us-ascii?Q?WVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QWJnQmhB?=
 =?us-ascii?Q?RzBBWlFCekFGOEFjZ0JsQUhNQWRBQnlBR2tBWXdCMEFHVUFaQUJmQUcwQVlR?=
 =?us-ascii?Q?QnlBSFlBWlFCc0FHd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1BWHdCeUFH?=
 =?us-ascii?Q?VUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFC?=
 =?us-ascii?Q?ZkFHOEFjZ0JmQUdFQWNnQnRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJR?=
 =?us-ascii?Q?QnBBRzRBZFFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?MEFZUUJ5QUhZQVpRQnNBR3dBWHdCM0FHOEFjZ0JrQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQT0iLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4612:EE_|BY5PR18MB3362:EE_
x-ms-office365-filtering-correlation-id: 8fbd4452-19fc-4268-c690-08db5712b87e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 bm9iDkte6TQUQTcwDHXyajQUTMGjS3AL7U2KQDyR6jXnABU7j3fILmmZCrJ6ZxDYTeYoM/AhNTPp8lM74ToIh3Z/Pk+qeLXv67B75Ht655tZ3kiKdOSv/vkZPbVSNvPnHkjI5Qxyl18rWgoJBfkm9K2bDI4dDDPBVFtS0oY42+tyxDa7t8M0HnHlU/87VQgm9VTVirAoLTREJXJ1iVtS5+JttpY+4R24Rvn/NxnrevEnJjvzqkIn8+nT+T7rrQRpKbx4Bvo3l+Z/YHYzefS44YB1uBbpjYgdNclsRpoXl9v3rJ80tmLsWGO5XH/XNRABdBY165/RCwLnrlHQxORlsH5ntgNLU2tKIeo+eoCDj+mi0Z6mjdHNY4xsUhPw9TGgUJvPG6aRHkrjOT/bwmKwfR3ozBiWOv8UVLlV2XZkrI53YK1IVF/SY4qkNvOQjcnxD8KCa5jmTU8bJ3NRGUb5nRSsW16KBocF1IRly3NhZvkaRHwDc/x/vfPCHatInIRNBSR/3col5mS+2OgbelEl/SOkAxMkxtylf+7nMnVp12A9Ud+jzQNkFV4XjS6f2l3cp2azcjoKCBfYE/NClAreJ6AhCCh8Vax3wPTGSmU+lyjY7IVu0M4VhyNMD7FKDjKO
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(2906002)(71200400001)(55016003)(5660300002)(86362001)(122000001)(52536014)(6506007)(186003)(26005)(9686003)(53546011)(8676002)(41300700001)(33656002)(8936002)(4326008)(316002)(38100700002)(7696005)(76116006)(38070700005)(478600001)(54906003)(66946007)(64756008)(66446008)(66556008)(66476007)(6916009)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?anwswBbg+y3jTkXzMYfzy736qhbf01BB7Y1Mk1KYAK0MRBNUtuGixT/QJLTT?=
 =?us-ascii?Q?+I+p1gi2ciI7SELj8F/aCkCkCno+T4v61AfCC8Zy3JGV9+7eQh3ZfLk6CSR6?=
 =?us-ascii?Q?P8qcwkxjB6Mke8GvqvZKSeLr5U28Je1NANt0HHwpbRcRSrC8lagQ1CsDkSrY?=
 =?us-ascii?Q?5eXIlu5iVn80o+TmfX3Oq3IQlGloX2z0V3ijwvgxL8P+lB31S+IpJ1zyqAJY?=
 =?us-ascii?Q?NkqlbkaTKS125wo8W621wkXn5WXwZPqeD9EKIkSe9GzBOrptpsaJ7ZarkEIX?=
 =?us-ascii?Q?SSoEBPApNLjpPmXNMrxV5wzsdi6EchAzzQVDmWF9APKfC+8L4bJQEjuR3Se4?=
 =?us-ascii?Q?n6L5tCs5S9/0bAZrtkRlgq/khW5XwHVzFdYMo1mIcRLoW9bmO1AM4z5cBo9G?=
 =?us-ascii?Q?bpywUA1LasDOMOk8SQVgO1SFbJg2fMx1S50qmhDrxmh0nblHzNgGLhZ1kMBt?=
 =?us-ascii?Q?xhCiZDH/a8Lohl/VBwLxDR1e+OVN0hTCB1AE/+K/Q2cmfuLynomOanLhSq5r?=
 =?us-ascii?Q?7NshpJMhpvWN2Ea5wOurljR6GAE/MINjpJPU35mP0Gx4zOE24iMXC4t9JsDH?=
 =?us-ascii?Q?kqFB9qCu4qMns2EezXlY4YRg5Vc9kyAJEgCad245ottvAFjQ2VINy43wfMpX?=
 =?us-ascii?Q?ClR4qJWICG/m99JGR20VC2g7QNlXD+05SFUDjye+C6xtBJkO0fnDmSFAQYtn?=
 =?us-ascii?Q?tzQ4RZJInxLkM7dyMUtc972b+Ziz5TDoUr9C8YGhUdUNK/s2LZVKknJFM3O3?=
 =?us-ascii?Q?1xbTrRJRN4aZ/7rDLWff4TOqJVuqqnpcw7bi6nbcePcu9NDSsffMQa+oSTBK?=
 =?us-ascii?Q?VP2c7kIPEL/+XbDF6clJStNLczw+iBrySdRMBptaDVqysEUmRCm2IMpkZgoe?=
 =?us-ascii?Q?Q7Nn8Wcm2O6KRBiQV2Iqfuj2qnbcD0S5KoGxsdgqILEqnY8d8KRVsclleQgb?=
 =?us-ascii?Q?hkEbePGKG7smHPtw0ah1v9BkKfF+46vWXzDy6Re6siOrbjwJX2LGcH6wzmBr?=
 =?us-ascii?Q?/UxiPmcwnBGtHw9ZgFnYq+swkiP9M3JvK1a30mjyfHzAnx3Zr3Umrz/K/bk6?=
 =?us-ascii?Q?tev4tsz7VMQvH/FI9Kt7ZTgnKacGvvScyfGlc7rDOqNuqDvm8E5GJbIUTXGu?=
 =?us-ascii?Q?2MHFRGjw85mZ0pDEHEJc/VvNfyJHIq/IfVFEfBVB3HOCUw1XlLjwsash/ycf?=
 =?us-ascii?Q?g7tDORBxYeTEFEgf7AWcQgbjbipUylIOcej6nMGugOKvhSeIrGrNFX8zrodS?=
 =?us-ascii?Q?S3L/QSgIjZnf5yB4RwGCcn1idgU2yLHAN7O1ObtDL1nb+iOHsNbT2arPj/AR?=
 =?us-ascii?Q?27ct3sx78LXWphG3QIzB3mJIdFNvAqpcFpKPKMJ2uI42768FKCbb1gPgLc+2?=
 =?us-ascii?Q?aGyNk44sAGEXS5r6iMVzrVVeKF+2+kdDInso0O2aTVG1EHBPGogITJlQOAZW?=
 =?us-ascii?Q?6+WUDxFxpCdsMCnDmttx1sYdb6yvgrNzWMg2av9hqXjz/eSHp0iSWa4pIt5P?=
 =?us-ascii?Q?c4Jraz53sK/HcAhkkSvposi81KPUWp58ZTtVwwEVPx1aysrS6f+6xnDS8yIw?=
 =?us-ascii?Q?x/wpVX9yE6MYHYNih7o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fbd4452-19fc-4268-c690-08db5712b87e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 20:10:11.9332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3z25YDcOEq99oDPWvnKc2qOpDJ543Gk194w8dTzwKDv8PjO0G91SxKJeydYzzo10tQRz0c34nnL59P0AdSeocA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3362
X-Proofpoint-GUID: 6e64xCpS03rqZO-TnwU0OHqiOlHJ6W8P
X-Proofpoint-ORIG-GUID: 6e64xCpS03rqZO-TnwU0OHqiOlHJ6W8P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_04,2023-05-17_02,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, May 3, 2023 8:33 AM
> To: Manish Chopra <manishc@marvell.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>;
> netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Alok Prasad
> <palok@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> David S . Miller <davem@davemloft.net>
> Subject: [EXT] Re: [PATCH v3 net] qed/qede: Fix scheduling while atomic
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Fri, 28 Apr 2023 10:26:51 -0700 Stephen Hemminger wrote:
> > On Fri, 28 Apr 2023 09:13:37 -0700
> > Manish Chopra <manishc@marvell.com> wrote:
> >
> > > -		usleep_range(1000, 2000);
> > > +
> > > +		if (is_atomic)
> > > +			udelay(QED_BAR_ACQUIRE_TIMEOUT_UDELAY);
> > > +		else
> > > +			usleep_range(QED_BAR_ACQUIRE_TIMEOUT_USLEEP,
> > > +				     QED_BAR_ACQUIRE_TIMEOUT_USLEEP *
> 2);
> > >  	}
> >
> > This is a variant of the conditional locking which is an ugly design pa=
ttern.
> > It makes static checking tools break and a source of more bugs.
> >
> > Better to fix the infrastructure or caller to not spin, or have two
> > different functions.
>=20
> FWIW the most common way to solve this issue is using a delayed work whic=
h
> reads out the stats periodically from a non-atomic context, and return a
> stashed copy from get_stat64.

Thanks for the suggestion, I will send v4 soon with required changes.

Regards,
Manish

