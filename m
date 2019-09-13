Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD84FB1A9B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfIMJRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:17:09 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45615 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387424AbfIMJRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 05:17:09 -0400
Received: by mail-oi1-f194.google.com with SMTP id o205so1549689oib.12
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 02:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=W+7OCyU4oIRxDa2T6/OVUqLpWvkhp0z6JtGuxMzwCW8=;
        b=bM7tF2h1Y++OBliX1bgLh/5Q68tLHskJXjkvlUs583ijAjTeN0Q0R85+I7syjtvo/N
         kfLU0/9ExX94pSUY9O+1SF2gsE5WYPdLvQfnZ7TOn0HouZiagJzJOuCabtqSjGUKrT2j
         WgS9qtbi/y7vZ5giBbI9HQ2CJYJrlPxRWEVi9X2hA+GdyUbDhxlhyT+jgLIlA/J1MTaw
         CPsF2ABDbGPU14PZXPWSNcCXKUawwGK4TDu2zDm1BkntiCq/c7++ILkFtof72vokVAvc
         V2Q4gg8UKnlu1y18zwSbQtjzTokeSx2oRo7kXJOgJjEtIuiopf9ENCSW+47a/V1T+RYa
         iStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=W+7OCyU4oIRxDa2T6/OVUqLpWvkhp0z6JtGuxMzwCW8=;
        b=rLyceK+v0gm1yHYuC0qzi2ea99lr3eczdwxFsvCidQaClO1Wb0ZFni8hjGthfPGnXP
         3sY+moLeF/MJziRy2PgGW3e/cteulQFCGysYQans5XJ7QO3+7JcIl033uGsfuVfEkIN9
         oJYMaK+u9TcsDM8nNiF8DRuhE70HvYe2BICpihMR7A1OskCJHxkIRjq42mnkyzvEJrQe
         1b+j0oVFQ/7Q5hqUu5QDqs+kKYGNYxkhVtALlPoDmC7OhPwh5KmQte/Eb5SagARAH6Hc
         sBd5w/a0/snV0pO7I1hVrIOVAuSxB+t/HH92X9xmT4x/HLelj6zzAFN0c7xS548tLYnM
         9rpQ==
X-Gm-Message-State: APjAAAXP4ym+3vTjQmBSWPoXEDSydSo6/rVtCDjSX2n1tYTeX4vn/Q3A
        i4Ot1F1TctkrLb+qDE2HXLV7vMrb7GRxvgl54sU=
X-Google-Smtp-Source: APXvYqyj/wK5aZIlawog9WHdOQZ6VgqKA6d6bFa3Hy4JaC7IyZfEcu8JoIpVzRJBjYwYoRgNX4k0SLXoKbGyMz5k85E=
X-Received: by 2002:aca:a9c3:: with SMTP id s186mr2401390oie.60.1568366228106;
 Fri, 13 Sep 2019 02:17:08 -0700 (PDT)
MIME-Version: 1.0
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Fri, 13 Sep 2019 19:16:42 +1000
Message-ID: <CAO42Z2yTw-pnKH01V7nyuXaT2R95y_WZ+7HpDmVCgROzNhEY6w@mail.gmail.com>
Subject: "[RFC PATCH net-next 1/2] Allow 225/8-231/8 as unicast"
To:     dave.taht@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

(Not subscribed to the mailing list)

I've just noticed this patch.

I don't think it should be applied, as 225/8 through 231/8 falls
within the IANA designated Class D multicast address range.
(https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.xhtml)

Using this address range as unicast addresses would mean that ICMP
messages would need to be able to use them as a source address.

However, Internet Standard number 3, RFC 1122, "Requirements for
Internet Hosts -- Communication Layers", prohibits using addresses
from within the multicast address range from being used as source
addresses:

"       An ICMP error message MUST NOT be sent as the result of
         receiving:

         *    an ICMP error message, or

         *    a datagram destined to an IP broadcast or IP multicast
              address, or

         *    a datagram sent as a link-layer broadcast, or

         *    a non-initial fragment, or

         *    a datagram whose source address does not define a single
              host -- e.g., a zero address, a loopback address, a
              broadcast address, a multicast address, or a Class E
              address."

Please note, IPv6 has and is being widely adopted. Trying to extend
use of IPv4 should be considered an unnecessary, in particular when it
violates Internet Standards.

There are more than 75 000 IPv6 routes in the Internet route table.
Nearly 18 000 BGP Autonomous Systems are announcing at least one IPv6
prefix.

 http://www.cidr-report.org/v6/as2.0/#General_Status


A number of countries have exceeded 50% IPv6 capability and preference
according to APNIC.

https://stats.labs.apnic.net/ipv6


Globally, Google are receiving more than 25% of their traffic via IPv6:

https://www.google.com/intl/en/ipv6/statistics.html

Regards,
Mark.
