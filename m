Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD616E99A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgBYPIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:08:54 -0500
Received: from mail-dm3gcc02on2100.outbound.protection.outlook.com ([40.107.91.100]:9290
        "EHLO GCC02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729867AbgBYPIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 10:08:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEw4ZFDLL2vg3TTrJkJ8KmM8kpshYPfB3wz8iietwFFmuim2SoELSkv51EspP4CIO6/phJN4BHGnYOQflyimMy2Q+TrLAicxAiu9LjFzZkaKT4ZGKZkPx4YGYhVJV8AWbj+G6oAwK9ITRJTu/QNcyYyqc8mLsDb6ZpgVvXEWGoO0pETc4+EPhlma8RtGvQuL5oN1E5xLhcn2JK1YsQFtabYYgmtWIKHI1ZbY4mkWO+41umZhqwUAYRxR6U6V/wcMYm2vB9D8wMwvPJbR0n/Lg0dRwVib4vfbTy0SuVwddeNwNJYkVeju14q3HpRokpP2j6I+r3wf98CeeEsEM3dKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYfx6agc+069434Rrl44UUzpZ8QrIX1E5cUcvFtOV+Y=;
 b=YKkdNRiq+DB8LxAn9Vhuy4cepOj+MKCX+3NXaYngo0Zsg4b/6RqcPlNJUkmKMHOhbNY3Ifl5wILRZETBo6YT+Pl91+nGDkY93+5wiEvq8RQ2P4PKZmO0nK/wQ1Iz8KG7MEiQk+mp10EFMkdPsvLmUOXw7RdUbK89kzxMHywwXm4n3Q2bHo62hKgmeULoQD/2dnFTsaEDezLJw/+vj1nGoWPwCQjz9Wx4LbScSMEUOHjAgpSnbSuw7paiLfujBKpQ8Jro3cy19VE+wWphhCbEcurmYEkIMxjs2lvhvit++/8Bq4baUaRuugDA4PiXXi0hiPNNY68zJXMVH2Fk/JOawg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fnal.gov; dmarc=pass action=none header.from=fnal.gov;
 dkim=pass header.d=fnal.gov; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fermicloud.onmicrosoft.com; s=selector2-fermicloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYfx6agc+069434Rrl44UUzpZ8QrIX1E5cUcvFtOV+Y=;
 b=QFER5bsEFhI8m4YKVgeYMi/hlw+j1KoZn6IX5sb/QFygdJblEaLV+1zsaRdTxLth68GEKREzAUL9uyW/pIav5pud3agVQUpwwB9lXLKGone2zJU2Xd8K+uR1hhqkGpiLF7ZxxwN+PXcA2Lzq6uiFofpANJyD1GqYeuM2ZJqyLrw=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=ron@fnal.gov; 
Received: from DM6PR09MB5669.namprd09.prod.outlook.com (2603:10b6:5:263::7) by
 DM6PR09MB3580.namprd09.prod.outlook.com (2603:10b6:5:16d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Tue, 25 Feb 2020 15:08:51 +0000
Received: from DM6PR09MB5669.namprd09.prod.outlook.com
 ([fe80::1ce3:cb24:19e4:10af]) by DM6PR09MB5669.namprd09.prod.outlook.com
 ([fe80::1ce3:cb24:19e4:10af%4]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 15:08:51 +0000
Reply-To: ron@fnal.gov
To:     netdev@vger.kernel.org
From:   Ron Rechenmacher <ron@fnal.gov>
Subject: retransmissions/out-of-order packets with large (~1 MB) writes/reads
 w/ TCP (SOCK_STREAM) over localhost loopback
Message-ID: <2849a9af-999d-822a-9e65-b3e1d3e67f42@fnal.gov>
Date:   Tue, 25 Feb 2020 09:08:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:610:59::22) To DM6PR09MB5669.namprd09.prod.outlook.com
 (2603:10b6:5:263::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:249:1000:1d70::2549] (2601:249:1000:1d70::2549) by CH2PR03CA0012.namprd03.prod.outlook.com (2603:10b6:610:59::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 15:08:51 +0000
X-Originating-IP: [2601:249:1000:1d70::2549]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6505651e-367d-4004-6226-08d7ba049f52
X-MS-TrafficTypeDiagnostic: DM6PR09MB3580:|DM6PR09MB3580:|DM6PR09MB3580:
X-Microsoft-Antispam-PRVS: <DM6PR09MB358041B20DF7AE7BD8E9DF44DCED0@DM6PR09MB3580.namprd09.prod.outlook.com>
X-Fermilab-Sender-Location: inside
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(346002)(376002)(396003)(366004)(189003)(199004)(6916009)(3450700001)(36756003)(6486002)(8936002)(2616005)(186003)(8676002)(316002)(2906002)(16526019)(52116002)(81156014)(66946007)(66556008)(66476007)(478600001)(86362001)(81166006)(31696002)(31686004)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR09MB3580;H:DM6PR09MB5669.namprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fnal.gov does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ALz9ufigPGUjTLNtC4vEdAKisB3drAOeJgsbz8lF5ybXutSQA0y9vPJMx+S0Wo4Njtz2EVaQzB2y9+C3KqzKHwz8GrEDFBbChQjgRXHxlwAw5vOsFIIbonPEhnQyGYa5eQS3vpc8iiF+S0s6rWJFApnyJLL+5ASwNuE83Z0yI/4CjyLotJXDHNi027EfkLy+DZXWWEeAwHAN08hDHdWdRSiuZBrTY4CXEET1AKI7GyAKHMJwIRRJqFV28KiHWzepditx1deg9jAtL8L2N5NLugCt9VHx1J96VgB6LOUOKe6bjOpzNP+gxTHB7Mo6O584BEBsouroL8pFFJ5bTLUZJ+2FKcVkeYlQ+Sbn0TXWo8mF4DH+CNQA0mqwrVom5gXo8GBf7BJwvGYrrxMyax9vtFElST/X1EyqsJHelZoGkB7FRjrgBKBC5/rEBezdN9Bo
X-MS-Exchange-AntiSpam-MessageData: K0dNTHK+rZl/ubbsmzHMhmSVtFX7ZiKjGdn8ZDe4K42wsw1LQDEA0eExOOKoFfIoURnV2pE7RMJoKlTCv3WC6onGOmBgIWRTu1NgPuppExDl6gDh3+nF/DBZEDZo45kNyRIPEGb3+BH+yJ5AgwU9HPw1NH7p3+QXckTTKCd8NuWFObHwjIfa2Kvk91pcIQLj
X-OriginatorOrg: fnal.gov
X-MS-Exchange-CrossTenant-Network-Message-Id: 6505651e-367d-4004-6226-08d7ba049f52
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 15:08:51.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 9d5f83d3-d338-4fd3-b1c9-b7d94d70255a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jH26+kOAKTwZ6SRkybNtbE4MbFKBnCcalRitmu579DcmnS+ODDiC9pm7O1lFfVeF6Hc3lIqUlRoQfAAT7bERg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR09MB3580
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm seeing this and have been googling for days to try to determine if I should be
surprised by this (which I am) or if anyone else is seeing it, but I haven't found any answers.
Apologies if I'm just missing something. Someone mentioned a loopback specification,
but I can't find it.

Here's one thing that I'm doing (tried on several modern kernel, including 5.5.4):

sudo tcpdump -s78 -wt.tcpdump -ilo port 7001 & tcpdump_pid=$!; \
taskset -c 1 ./tcp_loopback.py -s -b1048576 & sleep .5; taskset -c 2 ./tcp_loopback.py -c -b1048576 --count=8192; \
sudo kill $tcpdump_pid; \
tshark -r t.tcpdump | grep -i retrans

The tcp_loopback.py script is available at home.fnal.gov/~ron/tcp_loopback.py

The heart of the server portion (-s) is:

sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
     sock.setsockopt( socket.SOL_SOCKET, socket.SO_REUSEADDR, 1 )
     sock.bind( ('127.0.0.1', port) )
     sock.listen( 4 )
     sockconn,address = sock.accept()
     while 1:
         data = sockconn.recv(bs)
         if opargs['-v']=='': print('received: '+str(len(data)))
         if len(data) == 0:
             if opargs['-v']=='': print('0 data, closing')
             break

The heart of the client portion (-s) is:

     sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
     sock.connect( ('127.0.0.1',port) )
     for xx in range(cnt): sock.send( '*'*bs )

The probability of retrans seems to increase with larger (i.e. 2M, 4M) writes/reads.

I've read (e.g. Documentation/networking/scaling.rst) about out-of-order issues related
to scheduling on different cores, hence the use of taskset above.

Is there a way to prevent this from happening (while still using large writes/reads at
high rate)?

With loopback, don't really know if I'm looking at the send processing sending things
out-of-order or the receive processing receiving things out-of-order. My ultimate goal is to
establish a baseline for low-latency inter-node transmission in a 100 Gi, high congestion
(many-to-one) environment. I developed an application which uses the "debug socket" to get
retransmission information and I was surprised to see retransmissions on localhost.

Can anyone please help me understand what's happening and if there are any knobs to turn to
eliminate retransmission while still maximizing data rate?

Thanks,
Ron

Example output:

/home/ron/notes
ron@ronlap77 :^) sudo tcpdump -s78 -wt.tcpdump -ilo port 7001 & tcpdump_pid=$!; \
 > taskset -c 1 ./tcp_loopback.py -s -b1048576 & sleep .5; taskset -c 2 ./tcp_loopback.py -c -b1048576 --count=8192; \
 > sudo kill $tcpdump_pid; \
 > tshark -r t.tcpdump | grep -i retrans
[1] 31571
[2] 31572
tcpdump: listening on lo, link-type EN10MB (Ethernet), capture size 78 bytes
207707 packets captured
415440 packets received by filter
0 packets dropped by kernel
[2]+  Done                    taskset -c 1 ./tcp_loopback.py -s -b1048576
77373   0.442572    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3201826393 Ack=1 Win=65536 Len=65483 TSval=2684544027 TSecr=2684544026
77374   0.442574    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3201891876 Ack=1 Win=65536 Len=65483 TSval=2684544027 TSecr=2684544026
77375   0.442576    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3201957359 Ack=1 Win=65536 Len=65483 TSval=2684544027 TSecr=2684544026
79452   0.454359    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Spurious Retransmission] 44842 → 7001 [ACK] Seq=3313696610 Ack=1 Win=65536 Len=65483 TSval=2684544038 TSecr=2684544038
79453   0.454362    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3313893059 Ack=1 Win=65536 Len=65483 TSval=2684544038 TSecr=2684544038
79454   0.454365    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3313958542 Ack=1 Win=65536 Len=65483 TSval=2684544038 TSecr=2684544038
79455   0.454367    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3314024025 Ack=1 Win=65536 Len=65483 TSval=2684544038 TSecr=2684544038
79456   0.454370    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3314089508 Ack=1 Win=65536 Len=65483 TSval=2684544038 TSecr=2684544038
79457   0.454373    127.0.0.1 → 127.0.0.1    TCP 65549 [TCP Retransmission] 44842 → 7001 [ACK] Seq=3314154991 Ack=1 Win=65536 Len=65483 TSval=2684544038 TSecr=2684544038
[1]+  Done                    sudo tcpdump -s78 -wt.tcpdump -ilo port 7001
--2020-02-25_09:02:16--


