Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E891746E637
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhLIKKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:10:33 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:20221 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232521AbhLIKKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:10:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1639044417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xuaqq+TK5txxjZmFEYlFGes3WhCa/FwqR+3jiKIBW+k=;
        b=CMFOpWKOj/f05aKiMnb13k3ryT81txX/fn3uOTB61ne1xn6KXogjCYkT8qUiDVopCOybd6
        gw4u4JrQXs5dMjOcr/x4stNApT01l9pmeF++UTgdhO80ekg57Uv68UESXLDA8fmD0U7vf7
        bmEBX3/l3NWIunKHpX0O0v55/xLKhBM=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-GXHhRdlPPy6JCQ2xj2vq7g-1; Thu, 09 Dec 2021 11:06:56 +0100
X-MC-Unique: GXHhRdlPPy6JCQ2xj2vq7g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHVQ4SakFT75IhrcrhSoD8vWSsBIkJyNkQVVUYvMQliJIvVmhx32teXegtKQpF9CK3OIlgb5YT3hIGAs6yZbLEyK1qINtCP6Mv7H2gCDzmOgw0jn1NwQZsZXHXA3y9AWRDL10R3cPVHuPVj2iC0CO7uEgYK2w7gWoTNkDHixE4KF3gU7VtfUOAS41jMw7UO/6kNCF7nO+3w0cBsaPFZPJXsZxWzUPxIQ/ShgikEdZpQh1ScDG2XzvEwC7O2gWhu0t4Abj/m5S+j97+6AJOknuAWIbzabsViFO7XH0M42fzLbjzVV4KTgT1zyzHnL268IRXQFOhgiiPQluUkmBKtXYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5REqqNigqfVz9688iF4np/rlOakpvuKQcZxDiAdl7Ew=;
 b=RhXFYUnJN448HITmJm+8G9OPY2yDj7ZKgFzmtj7zEShP/mpu5H8qNRAKQry9KVK0TU1VUFYl7NK27EZ39PjIK4BLBDKlDHXeiCnWN1es6NHXUYFyeQ94o+e5vQ+v9EaXJYTE9fEZIm0RPp3HnIwmAnGVh1rp5fIPgO6Bw2KDZ4p8g6g4Z3/q37cYckwRQE4G90HfD+EtcTRvegOazqTSuf3CfaD1BX90dZo+zNEk+NhPpW8RsWdXL+l4OZdfANPTZx4LQnr4yjF5mzG3eBnAyPXP8VpaAMNZmOQAZ1xNYxK3sTKXPRXhmDstl3qgPw265FoQbAxC6Vb/cB/7+NCU0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB4140.eurprd04.prod.outlook.com (2603:10a6:5:20::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 10:06:54 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1%7]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 10:06:54 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 hci_cmd_sync_cancel
To:     syzbot <syzbot+485cc00ea7cf41dfdbf1@syzkaller.appspotmail.com>,
        Thinh.Nguyen@synopsys.com, bberg@redhat.com, changbin.du@intel.com,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        mathias.nyman@linux.intel.com, netdev@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
References: <00000000000098464c05d2acf3ba@google.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <3e8cba55-5d34-eab3-0625-687b66bb9449@suse.com>
Date:   Thu, 9 Dec 2021 11:06:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <00000000000098464c05d2acf3ba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM6PR0502CA0041.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::18) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from localhost.localdomain (2001:a61:3b82:1901:9d6b:5ffd:1b6b:2163) by AM6PR0502CA0041.eurprd05.prod.outlook.com (2603:10a6:20b:56::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Thu, 9 Dec 2021 10:06:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a79e8efd-4dda-40eb-5a8c-08d9bafba02f
X-MS-TrafficTypeDiagnostic: DB7PR04MB4140:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB41408FE31E4837B17EB87A6CC7709@DB7PR04MB4140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fwifnjoo/7o7nVBG1SHw2zYIExY0yR99jd5LEJQK4C6aU0jKpGdmG3vqFVlXeLzc23+Dz0leaYEoAdKKWzAGepo7PKqILfTRSz/lmyoKzIKnaxb/33J2i57+8M0gosMo9SDl7NLZUSNdQFEuxwHHw3bYO4FDHOiylFg4ZE4ABRYcmx2h5NBCpZr5aOZMfNDkLPUrxMU4NqD/c6RZfMV8tAZFPosYr83bUL8GjtB+X8KOP/aotYXoUaOa0cNbRE57iyyBXPRbxkUthTRdXtTTIppDsdoeXEtNGupPp00mHiUIuenJxYfObLMnB+OFMHN6lmo0kDfYvta1s77y5x9bOK1UUTXvrGWzubQTWQ3H11DEhF05UMzPj7CXrT4s8tmqt0ZZTEzivxuMulDlYGQQm2Q27rB6iLfJbJQLY5YP15pzBTnE/kPmPScsm1t+bBHEMvWtsKvpj+dhzTMPJXkZKUePnoNmcMqufyVVz1BviYLw+G/n+ILx64xuyebodMQ4Q7ed+jmLxznmrtj5s6/TcZSgbMCg290QwAF0zZ3bUY92W1OcWvACYaMIwCQIo4w13tQ/ZXKXhx5TauO/TJ5iH570PbOA9NYjUSFL18UiyeM6FiP2YScdmWzlY4hDh0hyxe382Bu8Chgv43VFbUhx+Tw8Hl1hMsEx+C0Q0yWmze4kUxg25HoD+/lwfJL/njAueJXkC05K/MLRKVg8jeM7IueUWSgtbM94cMQcT0pECK7wJoM74iXmcfBH7HVSueLo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(86362001)(31686004)(66946007)(508600001)(8936002)(6512007)(6486002)(6506007)(53546011)(186003)(2906002)(36756003)(31696002)(5660300002)(8676002)(921005)(2616005)(38100700002)(316002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lMaabn51fazXATP3ZMzkMXLd9s8AaET2wm3SUn49Cqf2PFPeCzo5O2gXpIR5?=
 =?us-ascii?Q?DuLCa/r6SU++Tde592FDrVBhXVcin+Cda+7wZn+eANdpa6Ser+sPK6hxY7Vm?=
 =?us-ascii?Q?YSM5K7vMoPDIzp47FRYmsQ6dsO3lg9/P0QV0samMYVX68BpsoqavZGoREOfG?=
 =?us-ascii?Q?kzLKM97Dj9kVt1rJrDmluJKP3ubXNd7CwxeErNhvWf9m2mKrb7C+B+BL4b9J?=
 =?us-ascii?Q?1Gif4NZJFNy69OCpJXjLxvbGtxPceTbgcDV8QJdbP2TANRFpby+/37Mqvpaa?=
 =?us-ascii?Q?O0NBCZ5CA64U3Ceh2TcAoFxZ0JKPu5kK+4lLQAhJjq6U8UdxbaGQtbAFYA9q?=
 =?us-ascii?Q?7xd9/CXPxBLF9IQbMNusf8GI2iy+AToOemLAnDWtB9crCtn/YbUW0mbfpQKJ?=
 =?us-ascii?Q?5GNGMwN6ngyaLOjLTFR/evdwVD3DQKemyaIqW9fLewjmE/wPQobN62O8TO9A?=
 =?us-ascii?Q?0smzSkEF9pjJdKgZ6ZN/AxIIkecStpsC3ybY37c/OnEierFq9ViyWRvH0IaB?=
 =?us-ascii?Q?cLI2rFtKsU27zOIXnQ+yokepRquQ9m54ZSYENXqdTyartgoFQ/WsRZk6zjzB?=
 =?us-ascii?Q?F7COS6J0iUdRYNZNMa0DiSlQ5O6Wn9VWEEa/uZaAtF3o7L4cIoRfP6769tLw?=
 =?us-ascii?Q?jJcvLCDlDb1Ts5uNqOHFnQw/mZuEf50m42PtQJtqha6JFa5UbqFcbA9hdH+l?=
 =?us-ascii?Q?LiKvmrKhX3k3rSwDFANnASzqSZco/F6tbQwEpEEuF7LOUOIt2rZchJ6cMNsS?=
 =?us-ascii?Q?ynbEO91Ysm0ibnC2IYm0qAebOs2TLWQqlNBsbGOCUd4OojaEhlqeH6Ud1HNs?=
 =?us-ascii?Q?KsNW3xxFXVH/ahI7iu8+sG1Q50ALxragA4OeEnZ+i3gN1MsXzXSwMzi/ACaf?=
 =?us-ascii?Q?p+b20a2RvsfFwkdBQFCGPgCTQL32EDo3YxJohtgI13+MxvQEFgHBYmRLd9/o?=
 =?us-ascii?Q?PyEpSqzpCwiOQ9cyHifPUYz4ZmcyLtZdrlTyBYpSJcJv9wf+hi/vk/mLnayu?=
 =?us-ascii?Q?+/zVrxpTLPi8LXyrf+MRQ2RWBmEITOYFxRX05DPxIt/YfrCApb/VibuwNXUD?=
 =?us-ascii?Q?2rJ5gTpYjThrVRWzxXpYrlj1JLJ7OF4OR8J9/sa5JMY3wERRzlnInO5Gx/Ly?=
 =?us-ascii?Q?Zkyt6doKatXB2ZfEOVXnbl4NRt3qB3Mh84W1X+x7UQ7WmViCydLwkviJ6R1f?=
 =?us-ascii?Q?vXfj/TdrgjRQd9eN6E8mj8859k588Kza0MYCOAaCGtp1HfnxWDqoaaRb1yb1?=
 =?us-ascii?Q?7p587b5MA+QepFvYAs/vJKS52HDYsaRQWf3SHpgMS1SIhj1qqHsy74chUn2C?=
 =?us-ascii?Q?EchP2lVYKxCXXV1DErsro42gdbXNkD/WPgChinZMY3NEns0ecp+fnJmYBCvB?=
 =?us-ascii?Q?OYrEE9t14qWsFyOVjMVnottUDMYCKToi3cS0WL1Gh8x+ofhdzwPw9lXHOPy5?=
 =?us-ascii?Q?cH9+GRF6NDVK7UPWRa+HLUDNv7NLLe7MlHf0DedaZNV8bRyGQkqhEgrpH1CT?=
 =?us-ascii?Q?4kyB7wFR0a1qvHSBe4OMpgpnW2QBc4AmHExKmzMT3yvLCKCl/VSTaDUXtgND?=
 =?us-ascii?Q?MoOU65dvFkLZinFBo8SGvsDsYoRrrEiUKjO7gurjWY9RdySRmkxUAJWoTbzJ?=
 =?us-ascii?Q?FkRh2ec3TrXRlxJk8kl0OvQ98TEWsnGKbTpNVm/iI8FRC7a1nhDlX62qswT0?=
 =?us-ascii?Q?2hrQ4Q6AbTybiu2yRdNtKVBsI3s=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79e8efd-4dda-40eb-5a8c-08d9bafba02f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:06:54.4256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3g/GFncj65zO8d1IbpHILEwVU2blMcP9f4H+AQ1PdCcQGMcDySCkFAzimWmZ0dQltEpF1Bc6BDiirdgxzuF0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09.12.21 02:59, syzbot wrote:
> syzbot has bisected this issue to:
>
> commit c97a747efc93f94a4ad6c707972dfbf8d774edf9
> Author: Benjamin Berg <bberg@redhat.com>
> Date:   Fri Dec 3 14:59:02 2021 +0000
>
>     Bluetooth: btusb: Cancel sync commands for certain URB errors

Hi,

looking at the patch, it sleeps in an interrupt handler (or equivalent)
in two places:

@@ -933,6 +933,8 @@ static void btusb_intr_complete(struct urb *urb)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (err !=3D -EPERM && err !=3D -ENODEV)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt_dev_err(=
hdev, "urb %p failed to resubmit (%d)",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 urb, -err);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (err !=3D -EPERM)
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hci_cmd_sync_c=
ancel(hdev, -err);


@@ -1331,10 +1335,13 @@ static void btusb_tx_complete(struct urb *urb)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!test_bit(HCI_RUNNING, &hdev=
->flags))
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 goto done;
=C2=A0
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!urb->status)
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!urb->status) {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 hdev->stat.byte_tx +=3D urb->transfer_buffer_length;
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (hci_skb_pkt_type(skb) =3D=3D HCI_COMMAND_PKT)
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hci_cmd_sync_c=
ancel(hdev, -urb->status);

As __cancel_work_timer can be called from hci_cmd_sync_cancel() this is
just not
an approach you can take. It looks like asynchronously canceling the
scheduled work
would result in a race, so I would for now just revert.

What issue exactly is this trying to fix or improve?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

