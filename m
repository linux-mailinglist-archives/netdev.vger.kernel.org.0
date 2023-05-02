Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765936F3FFF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjEBJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEBJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:22:00 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2027.outbound.protection.outlook.com [40.92.89.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54A346B1;
        Tue,  2 May 2023 02:21:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKY9hTKyzScNDonLJAWTh14gBf2HWjdM9bF+WdngNzpKjnXHrnDavwdiDZLripXnHcLZTKUgFccLGaEdEBTDAsktUeHQWeDbSYXjljzUNsC52YfSf4+R0vf6crLKym2vy8f6OQU/ds3NL4xhdHKZkGtfFYpxnPJU63FdKSehWKyPKZE8X1yK3LBsOWjU19msNX5l/ZoEYW99Vf8pRDVRk7XQOaV8rEIffaC+hVxc6I5pOLNSIYb1eCsGS5zS520N59IBgzyIx0aS3zBG2N3Oti8Ujq8aXoQ2ZXAEl+kkaZO1w0S3Q1Dt+Nde6e8gBnTQ/p6KJXSgStVDzmuhVqE7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Af8W3BBneE0KwIrXrICepzuByUpgw+uSvXpGjCP4F8A=;
 b=glzoCQ42IzMmqbXbdsNEMb1OCl/G2GStJxRgKOYhR8FK9ZJX6QXKYFFMmViNY/o5CQX7QVuNmantLiTLjgzdRARwhrO3FYg9J/8G9oZl2w3s3KwAp9rpXGjgBKokD0ZwVRi5ssNRuFh/4Kon7m9wZcoEgXyg0mwTDHLuFosko/iNau/Jbf4mXEwbnCqIEbN6KtQkiLqhkDJFtMhZHB9plZME406tLGNWfiKKi2bgS+xqkdOzC/5uwiDQiEhPz2DwsE5R4bq/Fwy+u5vgOfsLyktWyRo9NmK7mgILEE4WxtJrpv3OjdIy+ZE+JDViTFJva+EO21Q6RWgcj+B+qU9teQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Af8W3BBneE0KwIrXrICepzuByUpgw+uSvXpGjCP4F8A=;
 b=Nbs6iXKKWNk76tb3/np2dRSKtql8xdbWv1Npd9syVQku0AJej9BtQr70467e3Y96poR9ODdimO4juhrbdtuOrxXxq2wfsVjvlwn2CTqktOU7pHhgH8X6LvHZ4KrbrTz+pp8azNmbQj97HjVg9jKIItbrvyWlh27w+b/3BoGt3NMMBZXM282r/w+cR5Jc0KExYXo5iz9ERbc64cqDecXi2igyWiKg9+xgp0o1Zp+A/v/hY6Nrcrfq4Kd0M3N63pxhBw1nmU3kLySx/leeJwetZwgzyQZCW7781Q2oJ278DhTzeSgfqQPArHgqy9cQQ4YednOHtRbLPEfoaD7eaPIcYg==
Received: from GV1P193MB2005.EURP193.PROD.OUTLOOK.COM (2603:10a6:150:25::22)
 by PR3P193MB0879.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Tue, 2 May
 2023 09:21:55 +0000
Received: from GV1P193MB2005.EURP193.PROD.OUTLOOK.COM
 ([fe80::7394:8920:7e89:7cc1]) by GV1P193MB2005.EURP193.PROD.OUTLOOK.COM
 ([fe80::7394:8920:7e89:7cc1%4]) with mapi id 15.20.6363.019; Tue, 2 May 2023
 09:21:55 +0000
From:   Adrien Delorme <delorme.ade@outlook.com>
To:     "david.laight@aculab.com" <david.laight@aculab.com>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, "leit@fb.com" <leit@fb.com>,
        "leitao@debian.org" <leitao@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "willemb@google.com" <willemb@google.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Topic: RE: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Index: Adl81iNMMaEOfIisReufbmmHgji9HQ==
Date:   Tue, 2 May 2023 09:21:55 +0000
Message-ID: <GV1P193MB200533CC9A694C4066F4807CEA6F9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [SgPa94mCp/2QrRhbmCAlfHvb+fr5v4B5]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1P193MB2005:EE_|PR3P193MB0879:EE_
x-ms-office365-filtering-correlation-id: 4ef9b59f-c6d5-4863-8d1b-08db4aeeac44
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JMQCNOg91ASCk8lwzGrTQBdf84kD1l+AY1axiWCq9TmsMKqgqPYAuwn/gxqTb1dmWyipIoEGYwXygkynNyqKpwcpfh9Lu34oGNn9dwWgkX7wya71Q8kMkWNZzXwGnW1XWe9p5ispNkv6qrwA57oC6WPXBtWSSutMyIbf27VJOFQT70Dhoggxi/kXeBXAr/5JBIoeqwN9FIHz39YjjMNgAVX9NU+FUWVsfZ6xWZZ+S/GEDMjv5vZeW6gpmMw7r8fu3xld5CsJy7vheD9rew5iCV8Grw+pDARLYD9UBopbAtNn/jl5+ZEyH7bInopVca3DEmNOawmr/O3jRWyycuP7+Jk6h1tpd7jc1CbVyAV80rY1HTurZwha9AkHm7DTCLHp3TD7U71/6XV4K32YrZyfFDNS0OLcr3rlkkYeuovu9nWS1ENczKS19QSXymuNRhPLXX/rRuwprHmd+doLLnZiofJp5qhRl+XYV+afDtJP6dQmkpapopYtymJyHs74BKzrOW1lAGuNq0jHE8ceCsB1UOaMmnxfRWPOjmCsrXM55zsacF6QpdoXglg1aeYQZHke4FBQLjQ4oeqwNbyxmtCx+ApH4Urylj2L//gLqBlErSyCCBMepmHippqEtnpsG2Yo
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?40bVFCr8252aoLBBu8fhXGeb4lU1qNKTI8rHIJPXdP/BdMO1AzeUO7FisQhS?=
 =?us-ascii?Q?jMRVVha5UowCl/GqsQ7ePT8D1TQ0d5ZxaJi8V6X419wdeoGAAl2xZVTKGl7W?=
 =?us-ascii?Q?VXj+zP1sWahcwltrl/6fWLSbHQFW7ublGztGTo6DeL9zKfdvI0mYDAkAsPNp?=
 =?us-ascii?Q?Ym+mF5JoTaYcIiSDwMZ2nB7ni6iQc4TkPdo0GUlZMot4BY3EYGyrznUWl2R9?=
 =?us-ascii?Q?p/9Uj3mVqAZ4avU3FpvAh/+7G1AN3Ck2f1QmCgOOLQE/CcCscjSNW4RmYff/?=
 =?us-ascii?Q?dB61AMC5wciVsCXn342ogujL1RNDOtGkQDYhHTwCmI9ooPiCqm8CK7dNyjhq?=
 =?us-ascii?Q?xZLChc3PixV3J8XgwVBNuKh1JAwm4I8fqUcbue+2jXsG3zLRNYs1LBzUJXFo?=
 =?us-ascii?Q?+AxDni62cKfO6QhRLi0Wd9b2OIugm+bmxCzEE5yc68GkOHVAxrBoIob3xuJs?=
 =?us-ascii?Q?F9R6y9qTO9mLwr9URofy51o/R/rSILekO5BLfNZZX1uooBdAc3q67LZmOFSG?=
 =?us-ascii?Q?cYuhNyw/iHaE4eN+rO2nrIx5h6vgl4EpWEPEYO4X3Ld+5MRthmwvKlZpc6Lj?=
 =?us-ascii?Q?snAG+RluYEfckeIWytf2cakFdb+i7B02fMhZy6vYMOIazFnWQjV7b25acF22?=
 =?us-ascii?Q?L7LjX/TrJw2qWi6Iyjs6mlzY6I/bYdNzYX4mgIgGzO9/RbzCDH7ykffWkca8?=
 =?us-ascii?Q?RLpj/1IRDdTR4IUaQBrkG3/0HXDqniEU5YzXbQr58AUXn2N6SXVks3oDUJ6F?=
 =?us-ascii?Q?KguUKpo+akQJd1OtADsai5sIZ6khGVMMEOodBfy8cfDbtG8/qVGoQDFkbOjX?=
 =?us-ascii?Q?LF7qj8lA4oNJXG5gemf/PwOTFDW2f8sx/U5UPXr0GpN8eY3jW9to2N2gLtlV?=
 =?us-ascii?Q?9yDf4UIT3CwDUUemkHX+W/EbNQg2XBRDuLWqe6sUDT9ZdP071AwSnF+hFpEC?=
 =?us-ascii?Q?4PnxUtt1Z4M5ulW/AsVlgVeVQkTzBRXLm7wHu8VQZmKuGtWRmADYCC2IbYfj?=
 =?us-ascii?Q?hBWwedRgSlWTwgjzgFZLo/6bizrL+hlAW3qjJDOZTVZ5nEyryOJx3JALTGee?=
 =?us-ascii?Q?nw96+rjwtf6UV9rhfdhb7G1DWWn/xSDHaeuJN1EwAnCqtoN8z+SsZvq+KxXp?=
 =?us-ascii?Q?vysD2QJr4FYGiZSrMb8+WBSTiKi1sBBOd2oH7H16GIEeRDb4VBRZSd6e7rlk?=
 =?us-ascii?Q?CErueEFbanGQiur9qfeOSkzS6b2Zy+jnZom6bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P193MB2005.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef9b59f-c6d5-4863-8d1b-08db4aeeac44
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 09:21:55.5772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Adrien Delorme

> From: David Ahern=20
> Sent: 12 April 2023 7:39=20
> > Sent: 11 April 2023 16:28
> ....
> > Christoph's patch set a few years back that removed set_fs broke the
> > ability to do in-kernel ioctl and {s,g}setsockopt calls. I did not
> > follow that change; was it a deliberate intent to not allow these
> > in-kernel calls vs wanting to remove the set_fs? e.g., can we add a
> > kioctl variant for in-kernel use of the APIs?
>
> I think that was a side effect, and with no in-tree in-kernel
> users (apart from limited calls in bpf) it was deemed acceptable.
> (It is a PITA for any code trying to use SCTP in kernel.)
>
> One problem is that not all sockopt calls pass the correct length.
> And some of them can have very long buffers.
> Not to mention the ones that are read-modify-write.
>
> A plausible solution is to pass a 'fat pointer' that contains
> some, or all, of:
>       - A userspace buffer pointer.
>       - A kernel buffer pointer.
>       - The length supplied by the user.
>       - The length of the kernel buffer.
>       =3D The number of bytes to copy on completion.
> For simple user requests the syscall entry/exit code
> would copy the data to a short on-stack buffer.
> Kernel users just pass the kernel address.
> Odd requests can just use the user pointer.
>
> Probably needs accessors that add in an offset.
>
> It might also be that some of the problematic sockopt
> were in decnet - now removed.

Hello everyone,

I'm currently working on an implementation of {get,set} sockopt.=20
Since this thread is already talking about it, I hope that I replying at th=
e correct place.=20

My implementation is rather simple using a struct that will be used to pass=
 the necessary info throught sqe->cmd.

Here is my implementation based of kernel version 6.3 :=20

Signed-off-by: Adrien Delorme <delorme.ade@outlook.com>

diff -uprN a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
--- a/include/uapi/linux/io_uring.h     2023-04-23 15:02:52.000000000 -0400
+++ b/include/uapi/linux/io_uring.h     2023-04-24 07:55:21.406981696 -0400
@@ -235,6 +235,25 @@ enum io_uring_op {
  */
#define IORING_URING_CMD_FIXED (1U << 0)

+/* struct io_uring_cmd->cmd_op flags for socket operations */
+#define IO_URING_CMD_OP_GETSOCKOPT 0x0
+#define IO_URING_CMD_OP_SETSOCKOPT 0x1
+
+/* Struct to pass args for IO_URING_CMD_OP_GETSOCKOPT and IO_URING_CMD_OP_=
SETSOCKOPT operations */
+struct args_setsockopt_uring{
+       int                             level;
+       int                     optname;
+       char __user *   user_optval;
+       int                     optlen;
+};
+
+struct args_getsockopt_uring{
+       int                             level;
+       int                     optname;
+       char __user *   user_optval;
+       int      __user *       optlen;
+};
+

/*
  * sqe->fsync_flags
diff -uprN a/net/socket.c b/net/socket.c
--- a/net/socket.c      2023-04-23 15:02:52.000000000 -0400
+++ b/net/socket.c      2023-04-24 08:06:44.800981696 -0400
@@ -108,6 +108,11 @@
#include <linux/ptp_clock_kernel.h>
#include <trace/events/sock.h>

+#ifdef CONFIG_IO_URING
+#include <uapi/linux/io_uring.h>
+#include <linux/io_uring.h>
+#endif
+
#ifdef CONFIG_NET_RX_BUSY_POLL
unsigned int sysctl_net_busy_read __read_mostly;
unsigned int sysctl_net_busy_poll __read_mostly;
@@ -132,6 +137,11 @@ static ssize_t sock_splice_read(struct f
                                struct pipe_inode_info *pipe, size_t len,
                                unsigned int flags);

+
+#ifdef CONFIG_IO_URING
+int socket_uring_cmd_handler(struct io_uring_cmd *cmd, unsigned int flags)=
;
+#endif
+
#ifdef CONFIG_PROC_FS
static void sock_show_fdinfo(struct seq_file *m, struct file *f)
{
@@ -166,6 +176,9 @@ static const struct file_operations sock
        .splice_write =3D generic_splice_sendpage,
        .splice_read =3D  sock_splice_read,
        .show_fdinfo =3D  sock_show_fdinfo,
+#ifdef CONFIG_IO_URING
+       .uring_cmd =3D socket_uring_cmd_handler,
+#endif
};

static const char * const pf_family_names[] =3D {
@@ -2330,6 +2343,126 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int
        return __sys_getsockopt(fd, level, optname, optval, optlen);
}

+#ifdef CONFIG_IO_URING
+
+/*
+ * Make getsockopt operation with io_uring.
+ * This fonction is based of the __sys_getsockopt without sockfd_lookup_li=
ght
+ * since io_uring retrieves it for us.
+ */
+int uring_cmd_getsockopt(struct socket *sock, int level, int optname, char=
 __user *optval,
+               int __user *optlen)
+{
+       int err;
+       int max_optlen;
+
+       err =3D security_socket_getsockopt(sock, level, optname);
+       if (err)
+               goto out_put;
+
+       if (!in_compat_syscall())
+               max_optlen =3D BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+
+       if (level =3D=3D SOL_SOCKET)
+               err =3D sock_getsockopt(sock, level, optname, optval, optle=
n);
+       else if (unlikely(!sock->ops->getsockopt))
+               err =3D -EOPNOTSUPP;
+       else
+               err =3D sock->ops->getsockopt(sock, level, optname, optval,
+                                           optlen);
+
+       if (!in_compat_syscall())
+               err =3D BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, opt=
name,
+                                                    optval, optlen, max_op=
tlen,
+                                                    err);
+out_put:
+       return err;
+}
+
+/*
+ * Make setsockopt operation with io_uring.
+ * This fonction is based of the __sys_setsockopt without sockfd_lookup_li=
ght
+ * since io_uring retrieves it for us.
+ */
+int uring_cmd_setsockopt(struct socket *sock, int level, int optname, char=
 *user_optval,
+               int optlen)
+{
+       sockptr_t optval =3D USER_SOCKPTR(user_optval);
+       char *kernel_optval =3D NULL;
+       int err;
+
+       if (optlen < 0)
+               return -EINVAL;
+
+       err =3D security_socket_setsockopt(sock, level, optname);
+       if (err)
+               goto out_put;
+
+       if (!in_compat_syscall())
+               err =3D BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &o=
ptname,
+                                                    user_optval, &optlen,
+                                                    &kernel_optval);
+       if (err < 0)
+               goto out_put;
+       if (err > 0) {
+               err =3D 0;
+               goto out_put;
+       }
+
+       if (kernel_optval)
+               optval =3D KERNEL_SOCKPTR(kernel_optval);
+       if (level =3D=3D SOL_SOCKET && !sock_use_custom_sol_socket(sock))
+               err =3D sock_setsockopt(sock, level, optname, optval, optle=
n);
+       else if (unlikely(!sock->ops->setsockopt))
+               err =3D -EOPNOTSUPP;
+       else
+               err =3D sock->ops->setsockopt(sock, level, optname, optval,
+                                           optlen);
+       kfree(kernel_optval);
+out_put:
+       return err;
+}
+
+/*
+ * Handler uring_cmd socket file_operations.
+ *
+ * Operation code and struct are defined in /include/uapi/linux/io_uring.h
+ * The io_uring ring needs to be set with the flags : IORING_SETUP_SQE128 =
and IORING_SETUP_CQE32
+ *
+ */
+int socket_uring_cmd_handler(struct io_uring_cmd *cmd, unsigned int flags)=
{
+
+       /* Retrieve socket */
+       struct socket *sock =3D sock_from_file(cmd->file);
+
+       if (!sock)
+               return -EINVAL;
+
+       /* Does the requested operation */
+       switch (cmd->cmd_op) {
+               case IO_URING_CMD_OP_GETSOCKOPT:
+                       struct args_getsockopt_uring *values_get =3D (struc=
t args_getsockopt_uring *) cmd->cmd;
+                       return uring_cmd_getsockopt(sock,
+                                                                          =
     values_get->level,
+                                                                          =
     values_get->optname,
+                                                                          =
     values_get->user_optval,
+                                                                          =
     values_get->optlen);
+
+               case IO_URING_CMD_OP_SETSOCKOPT:
+                       struct args_setsockopt_uring *values_set =3D (struc=
t args_setsockopt_uring *) cmd->cmd;
+                       return uring_cmd_setsockopt(sock,
+                                                                          =
     values_set->level,
+                                                                          =
     values_set->optname,
+                                                                          =
     values_set->user_optval,
+                                                                          =
     values_set->optlen);
+               default:
+                       break;
+
+       }
+       return -EINVAL;
+}
+#endif
+
/*
  *     Shutdown a socket.
  */

I would appreciate any feedback or advice you may have on this work. Hopefu=
lly it will be of some kind of help. Thank you for your time and considerat=
ion.

Adrien
