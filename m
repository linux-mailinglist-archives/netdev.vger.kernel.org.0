Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C670287F3B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 01:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgJHXln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 19:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730758AbgJHXln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 19:41:43 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6F7C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 16:41:42 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id z9so186409qvo.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 16:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=nFFaJQBghagcloTs22skGuUImESS4OWZQeRlNi12tDc=;
        b=gGAheNpTYHvxFCbEuDFJwYt57f1qWB+czhjPBLWJvV6Om31+M74Ra5lWCYgSd26zMF
         NNFoQcxZdCfBzt47SBBhUg30WM9EXwVM+pjF4Eurm5utctlTakokYGUybik9HpjOnZHR
         7aPTOvu/bfqD8ydlkTqvdnNrjGrwoBEHp6KzZZxS5WIvI+xSzULB4rsCPPsecTpgUxoz
         uvsjV+rIQO/k7qr6u86joMmJI5ef9ut5HGID5Fxdda9ACocnlamzr9XuYAcPb4KtQ+PG
         PQGK0PokEL70pyMc8rzdIxadTUxVVnzSotpn52oVIC0MuuRqE7eH2DXXXIbOFUYJcwNv
         3kSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=nFFaJQBghagcloTs22skGuUImESS4OWZQeRlNi12tDc=;
        b=Hf6S59IxniINfmzDrumwNceDp0hlJtQksywjLaYvxGv0ELOZm9i1BGjVXbHy76fNun
         fHMu77ughQCYjiUGdY9MZaDC03VT3Z3elEFTxDsruUCLcOBzg58j1RSLOxJUEaPAjpcK
         4Ih64vdzK3al2H6oQ38OT+z3KGvE/ueyK3LFsb8OfYxPn9Y2mVHXKaAmdZoMdQwX03qk
         W/Fmn1Wsd84vyephBbEtrb183TnrPpU8To5mNLCmb0cuCeLJOj/2PaFZaHZ/fgzLdTEZ
         XBC1iF0XEfuopYhIDt2iSYobzSFondPLyrjh+VGQqbXobScxD7RK+zm8n9rL3wVoIb7d
         p++w==
X-Gm-Message-State: AOAM53339YCxOlZMAm3AuY0qUg/PG0y85thIAXNmpZGG6BdEuHB9H1T5
        R+rt4BPoaBgVqa2QIWgNBbTZARaI3H48qG12S5pqVQ==
X-Google-Smtp-Source: ABdhPJyAt7IMZsD8EVY4ebCtqaK57GoM1eaFAm9y45iXe05l7ZZlsByHkKiqheFkm9+jwAAAhrmEO/ACTmymVuiBYCQ=
X-Received: by 2002:a0c:9c09:: with SMTP id v9mr10614592qve.57.1602200501101;
 Thu, 08 Oct 2020 16:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
In-Reply-To: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Thu, 8 Oct 2020 16:41:30 -0700
Message-ID: <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after re-register
To:     open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, fw@strlen.org,
        kadlec@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Francesco Ruggeri <fruggeri@arista.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 12:32 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> If the first packet conntrack sees after a re-register is an outgoing
> keepalive packet with no data (SEG.SEQ = SND.NXT-1), td_end is set to
> SND.NXT-1.
> When the peer correctly acknowledges SND.NXT, tcp_in_window fails
> check III (Upper bound for valid (s)ack: sack <= receiver.td_end) and
> returns false, which cascades into nf_conntrack_in setting
> skb->_nfct = 0 and in later conntrack iptables rules not matching.
> In cases where iptables are dropping packets that do not match
> conntrack rules this can result in idle tcp connections to time out.
>
> v2: adjust td_end when getting the reply rather than when sending out
>     the keepalive packet.
>

Any comments?
Here is a simple reproducer.
The idea is to show that keepalive packets in an idle tcp
connection will be dropped (and the connection will time out)
if conntrack hooks are de-registered and then re-registered.
The reproducer has two files.
client_server.py creates both ends of a tcp connection, bounces
a few packets back and forth, and then blocks on a recv on the
client side. The client's keepalive is configured to time out in
20 seconds. This connection should not time out.
test is a bash script that creates a net namespace where it sets
iptables rules for the connection, starts client_server.py, and
then clears and restores the iptables rules (which causes
conntrack hooks to be de-registered and re-registered).

================ file client_server.py
#!/usr/bin/python

import socket

PORT=4446

# create server socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('localhost', PORT))
sock.listen(1)

# create client socket
cl_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cl_sock.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
cl_sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPIDLE, 2)
cl_sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPINTVL, 2)
cl_sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPCNT, 10)
cl_sock.connect(('localhost', PORT))

srv_sock, _ = sock.accept()

# Bounce a packet back and forth a few times
buf = 'aaaaaaaaaaaa'
for i in range(5):
   cl_sock.send(buf)
   buf = srv_sock.recv(100)
   srv_sock.send(buf)
   buf = cl_sock.recv(100)
   print buf

# idle the connection
try:
   buf = cl_sock.recv(100)
except socket.error, e:
   print "Error: %s" % e

sock.close()
cl_sock.close()
srv_sock.close()

============== file test
#!/bin/bash

ip netns add dummy
ip netns exec dummy ip link set lo up
echo "Created namespace"

ip netns exec dummy iptables-restore <<END
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 4446 -j ACCEPT
COMMIT
END
echo "Installed iptables rules"

ip netns exec dummy ./client_server.py &
echo "Created tcp connection"
sleep 2

ip netns exec dummy iptables-restore << END
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
END
echo "Cleared iptables rules"
sleep 4

ip netns exec dummy iptables-restore << END
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 4446 -j ACCEPT
COMMIT
END
echo "Restored original iptables rules"

wait
ip netns del dummy
exit 0
