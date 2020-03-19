Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4B18B9D5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgCSO6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:58:50 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:38748 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCSO6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:58:49 -0400
Received: by mail-pl1-f181.google.com with SMTP id w3so1174029plz.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 07:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=QG2RZb+BTryN8i49xjLkaQ5YR5Ti0pAT5u6H0IdRBv4=;
        b=Mdb2fG9MJyXN8LHINqle/3JaVDneR+XN7dHSQc8rmxxbzJ29aZMeltukXPXYIqPAsF
         8hMqCPXJm5ERVlZPjTAdokA8IRZbSUskmyqVXniwdkySH6ejdSPrUNo6nK7T6XGYbOe0
         HZNxTBHV/0sire7f9x6yMMSy6VA+K7UTSUgvHsXgrORwCD0xtYguivHnrqd+pncqfjPT
         4RP468s+ZArovJ9sCk7myEntjt6LnGnZKEGBjDaLJLZvZMjnWtLq6jtDuj19DCdedWSJ
         qtNX4X7XzgNUhoMQ2UFtXpeRm0oycNkE1KRi1nJ1o3kyhpGw7IL0RB7Bgc5VzcHpwK0K
         TdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=QG2RZb+BTryN8i49xjLkaQ5YR5Ti0pAT5u6H0IdRBv4=;
        b=eiquMBmtz0BLfxR7DBFT45pkNl+nBSbZkuan8yebOAq6YUzss17wWTi+wIBzqVBO5g
         oMeoWiJnWfF1LzisrEYwIelBFB3kPePxBHdIvuzFkxFu6sLmJAZOdqPh4Oa+d4wJUZpl
         O/ex0q86vyjgqltGxADDPvIeM9zMpHgnJS5v0RXHm3aLLCAkXOi7UV4Ga6DSmw2AUNCO
         Vc26WZRQGUpXwtH5NZjQ23NlegnvYYnmbCuPI9kyowIzmz8nXrsoIEzKlS/9BHQYg115
         4psSCAoK7tzje7wn51Ep7OfxXpAR4V1r8MhJljx+Loj7OgktUEYTjaZcFKDmhghnU1tS
         KdJw==
X-Gm-Message-State: ANhLgQ0kcYPuBiEiIjXuJYP2KcnoNFuSC3uaL2TmA47Fg3IrEsmHGLnN
        2uD1fUznFbk+80ReZNevJ/VsZa/+rCw=
X-Google-Smtp-Source: ADFU+vvsiWlmejKJ3gF2LbyVRw8XC0KodPI1rrRnCZ5H7kC93XxjLrpiAu0Sx0pVVRyrCQ7IDbKo0Q==
X-Received: by 2002:a17:902:22e:: with SMTP id 43mr3631716plc.119.1584629927662;
        Thu, 19 Mar 2020 07:58:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f19sm2724019pgf.33.2020.03.19.07.58.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:58:47 -0700 (PDT)
Date:   Thu, 19 Mar 2020 07:58:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206885] New: macvlan and proxy ARP can be accidentally
 configured to respond to ARP requests for all IPs
Message-ID: <20200319075839.0af55790@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My gut feeling is this a user error, but forwarding to get more eyes.

Begin forwarded message:

Date: Thu, 19 Mar 2020 13:48:01 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206885] New: macvlan and proxy ARP can be accidentally configured to respond to ARP requests for all IPs


https://bugzilla.kernel.org/show_bug.cgi?id=206885

            Bug ID: 206885
           Summary: macvlan and proxy ARP can be accidentally configured
                    to respond to ARP requests for all IPs
           Product: Networking
           Version: 2.5
    Kernel Version: 5.3.0-42-generic
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: thomas.parrott@canonical.com
        Regression: No

Using the following approach it is possible to accidentally configure a macvlan
interface to respond to ARP requests for all IPs.

Reproducer:

ip link add link enp3s0 address f6:83:72:e4:77:0a vtest type macvlan
ip addr add 192.168.1.200/32 dev vtest
ip link set vtest up

sysctl -w net.ipv4.conf.vtest.rp_filter=2
sysctl -w net.ipv4.conf.vtest.proxy_arp=1
sysctl -w net.ipv4.conf.vtest.forwarding=1


On a separate host on the same segment:

arping -c 1 -I eth1 -s 192.168.1.2 10.1.2.3
ARPING 10.1.2.3 from 192.168.1.2 eth1
Unicast reply from 10.1.2.3 [f6:83:72:e4:77:0a] 419.288ms
Sent 1 probe(s) (0 broadcast(s))
Received 1 response(s) (0 request(s), 0 broadcast(s))

arping -c 1 -I eth1 -s 192.168.1.2 8.8.8.8
ARPING 10.1.2.3 from 192.168.1.2 eth1
Unicast reply from 10.1.2.3 [f6:83:72:e4:77:0a] 27.754ms
Sent 1 probe(s) (0 broadcast(s))
Received 1 response(s) (0 request(s), 0 broadcast(s))


See https://github.com/lxc/lxc/issues/775 for more information.

-- 
You are receiving this mail because:
You are the assignee for the bug.
