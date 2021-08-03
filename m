Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F803DEC7B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhHCLnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:43:05 -0400
Received: from out1.migadu.com ([91.121.223.63]:62104 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235955AbhHCLmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:42:54 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627990960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGB6/xcegKXtu/8Ld2yXeGGGMgPGw4hVLuMWkPx0xWA=;
        b=lPJixahyjboxxccmSjjwvbELc+00x19863ufi6jDOaNo3Ll2PPidOz8LJiXkKjq/Bh1C4F
        tD4MksV49oDE9WdOkClbCvDjWGYvrS5KlWTkacmNv6v7CEvCV6uA062PwhWVziyWkWLlef
        p+d+bgh76Dc5M8tmfjDoimFl6C4ut4w=
Date:   Tue, 03 Aug 2021 11:42:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <a37faefd6dcad9f01212d60f8bb32f4f@linux.dev>
Subject: Re: [PATCH net-next] net: Modify sock_set_keepalive() for more
 scenarios
To:     "kernel test robot" <lkp@intel.com>, davem@davemloft.net,
        kuba@kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        mptcp@lists.linux.dev
In-Reply-To: <202108031929.b1AMeeUj-lkp@intel.com>
References: <202108031929.b1AMeeUj-lkp@intel.com>
 <20210803082553.25194-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_create_listen_sock() function was already dropped in commit <2dc6=
b1158c28c3a5e86d162628810312f98d5e97> by Alexander Aring.=0A =0AAugust 3,=
 2021 7:28 PM, "kernel test robot" <lkp@intel.com> wrote:=0A=0A> Hi Yajun=
,=0A> =0A> Thank you for the patch! Yet something to improve:=0A> =0A> [a=
uto build test ERROR on net-next/master]=0A> =0A> url:=0A> https://github=
.com/0day-ci/linux/commits/Yajun-Deng/net-Modify-sock_set_keepalive-for-m=
ore-scenarios=0A> 20210803-162757=0A> base: https://git.kernel.org/pub/sc=
m/linux/kernel/git/davem/net-next.git=0A> 7cdd0a89ec70ce6a720171f1f7817ee=
9502b134c=0A> config: m68k-allmodconfig (attached as .config)=0A> compile=
r: m68k-linux-gcc (GCC) 10.3.0=0A> reproduce (this is a W=3D1 build):=0A>=
 wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.=
cross -O ~/bin/make.cross=0A> chmod +x ~/bin/make.cross=0A> # https://git=
hub.com/0day-ci/linux/commit/1dd4cca54718feb13bbafafb8104a414ddc49662=0A>=
 git remote add linux-review https://github.com/0day-ci/linux=0A> git fet=
ch --no-tags linux-review=0A> Yajun-Deng/net-Modify-sock_set_keepalive-fo=
r-more-scenarios/20210803-162757=0A> git checkout 1dd4cca54718feb13bbafaf=
b8104a414ddc49662=0A> # save the attached .config to linux build tree=0A>=
 mkdir build_dir=0A> COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-10=
.3.0 make.cross O=3Dbuild_dir ARCH=3Dm68k=0A> SHELL=3D/bin/bash fs/dlm/=
=0A> =0A> If you fix the issue, kindly add following tag as appropriate=
=0A> Reported-by: kernel test robot <lkp@intel.com>=0A> =0A> All errors (=
new ones prefixed by >>):=0A> =0A> fs/dlm/lowcomms.c: In function 'tcp_cr=
eate_listen_sock':=0A> =0A>>> fs/dlm/lowcomms.c:1359:2: error: too few ar=
guments to function 'sock_set_keepalive'=0A> =0A> 1359 | sock_set_keepali=
ve(sock->sk);=0A> | ^~~~~~~~~~~~~~~~~~=0A> In file included from fs/dlm/l=
owcomms.c:46:=0A> include/net/sock.h:2775:6: note: declared here=0A> 2775=
 | void sock_set_keepalive(struct sock *sk, bool valbool);=0A> | ^~~~~~~~=
~~~~~~~~~~=0A> =0A> vim +/sock_set_keepalive +1359 fs/dlm/lowcomms.c=0A> =
=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 13=
19=0A> d11ccd451b6556 fs/dlm/lowcomms.c Alexander Aring 2020-11-02 1320 /=
* On error caller must run=0A> dlm_close_sock() for the=0A> d11ccd451b655=
6 fs/dlm/lowcomms.c Alexander Aring 2020-11-02 1321 * listen connection s=
ocket.=0A> d11ccd451b6556 fs/dlm/lowcomms.c Alexander Aring 2020-11-02 13=
22 */=0A> d11ccd451b6556 fs/dlm/lowcomms.c Alexander Aring 2020-11-02 132=
3 static int=0A> tcp_create_listen_sock(struct listen_connection *con,=0A=
> ac33d071059557 fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-12-06 1324 =
struct sockaddr_storage=0A> *saddr)=0A> fdda387f73947e fs/dlm/lowcomms-tc=
p.c Patrick Caulfield 2006-11-02 1325 {=0A> fdda387f73947e fs/dlm/lowcomm=
s-tcp.c Patrick Caulfield 2006-11-02 1326 struct socket *sock =3D NULL;=
=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 13=
27 int result =3D 0;=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Cau=
lfield 2006-11-02 1328 int addr_len;=0A> fdda387f73947e fs/dlm/lowcomms-t=
cp.c Patrick Caulfield 2006-11-02 1329=0A> 6ed7257b46709e fs/dlm/lowcomms=
.c Patrick Caulfield 2007-04-17 1330 if (dlm_local_addr[0]->ss_family=0A>=
 =3D=3D AF_INET)=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfie=
ld 2006-11-02 1331 addr_len =3D sizeof(struct=0A> sockaddr_in);=0A> fdda3=
87f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1332 else=0A=
> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1333 =
addr_len =3D sizeof(struct=0A> sockaddr_in6);=0A> fdda387f73947e fs/dlm/l=
owcomms-tcp.c Patrick Caulfield 2006-11-02 1334=0A> fdda387f73947e fs/dlm=
/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1335 /* Create a socket to=
=0A> communicate with */=0A> eeb1bd5c40edb0 fs/dlm/lowcomms.c Eric W. Bie=
derman 2015-05-08 1336 result =3D=0A> sock_create_kern(&init_net, dlm_loc=
al_addr[0]->ss_family,=0A> eeb1bd5c40edb0 fs/dlm/lowcomms.c Eric W. Biede=
rman 2015-05-08 1337 SOCK_STREAM, IPPROTO_TCP,=0A> &sock);=0A> fdda387f73=
947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1338 if (result <=
 0) {=0A> 617e82e10ccf96 fs/dlm/lowcomms.c David Teigland 2007-04-26 1339=
 log_print("Can't create listening=0A> comms socket");=0A> fdda387f73947e=
 fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1340 goto create_out;=
=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 13=
41 }=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-0=
2 1342=0A> a5b7ab6352bfaa fs/dlm/lowcomms.c Alexander Aring 2020-06-26 13=
43 sock_set_mark(sock->sk,=0A> dlm_config.ci_mark);=0A> a5b7ab6352bfaa fs=
/dlm/lowcomms.c Alexander Aring 2020-06-26 1344=0A> cb2d45da81c86d fs/dlm=
/lowcomms.c David Teigland 2010-11-12 1345 /* Turn off Nagle's algorithm =
*/=0A> 12abc5ee7873a0 fs/dlm/lowcomms.c Christoph Hellwig 2020-05-28 1346=
 tcp_sock_set_nodelay(sock->sk);=0A> cb2d45da81c86d fs/dlm/lowcomms.c Dav=
id Teigland 2010-11-12 1347=0A> b58f0e8f38c0a4 fs/dlm/lowcomms.c Christop=
h Hellwig 2020-05-28 1348 sock_set_reuseaddr(sock->sk);=0A> 6ed7257b46709=
e fs/dlm/lowcomms.c Patrick Caulfield 2007-04-17 1349=0A> d11ccd451b6556 =
fs/dlm/lowcomms.c Alexander Aring 2020-11-02 1350 add_listen_sock(sock, c=
on);=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-0=
2 1351=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11=
-02 1352 /* Bind to our port */=0A> 68c817a1c4e21b fs/dlm/lowcomms-tcp.c =
David Teigland 2007-01-09 1353 make_sockaddr(saddr,=0A> dlm_config.ci_tcp=
_port, &addr_len);=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulf=
ield 2006-11-02 1354 result =3D=0A> sock->ops->bind(sock, (struct sockadd=
r *) saddr, addr_len);=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick C=
aulfield 2006-11-02 1355 if (result < 0) {=0A> 617e82e10ccf96 fs/dlm/lowc=
omms.c David Teigland 2007-04-26 1356 log_print("Can't bind to port %d",=
=0A> dlm_config.ci_tcp_port);=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Pa=
trick Caulfield 2006-11-02 1357 goto create_out;=0A> fdda387f73947e fs/dl=
m/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1358 }=0A> ce3d9544cecacd f=
s/dlm/lowcomms.c Christoph Hellwig 2020-05-28 @1359 sock_set_keepalive(so=
ck->sk);=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-=
11-02 1360=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 200=
6-11-02 1361 result =3D=0A> sock->ops->listen(sock, 5);=0A> fdda387f73947=
e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1362 if (result < 0)=
 {=0A> 617e82e10ccf96 fs/dlm/lowcomms.c David Teigland 2007-04-26 1363 lo=
g_print("Can't listen on port=0A> %d", dlm_config.ci_tcp_port);=0A> fdda3=
87f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006-11-02 1364 goto cr=
eate_out;=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield 2006=
-11-02 1365 }=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfield =
2006-11-02 1366=0A> d11ccd451b6556 fs/dlm/lowcomms.c Alexander Aring 2020=
-11-02 1367 return 0;=0A> d11ccd451b6556 fs/dlm/lowcomms.c Alexander Arin=
g 2020-11-02 1368=0A> fdda387f73947e fs/dlm/lowcomms-tcp.c Patrick Caulfi=
eld 2006-11-02 1369 create_out:=0A> d11ccd451b6556 fs/dlm/lowcomms.c Alex=
ander Aring 2020-11-02 1370 return result;=0A> fdda387f73947e fs/dlm/lowc=
omms-tcp.c Patrick Caulfield 2006-11-02 1371 }=0A> fdda387f73947e fs/dlm/=
lowcomms-tcp.c Patrick Caulfield 2006-11-02 1372=0A> =0A> ---=0A> 0-DAY C=
I Kernel Test Service, Intel Corporation=0A> https://lists.01.org/hyperki=
tty/list/kbuild-all@lists.01.org
