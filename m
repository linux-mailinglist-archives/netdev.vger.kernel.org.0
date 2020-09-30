Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE0A27F178
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgI3SkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:40:13 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:58828 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbgI3SkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:40:13 -0400
X-Greylist: delayed 2667 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 14:40:13 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 08UHrskY065140;
        Wed, 30 Sep 2020 10:55:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=to : cc : from :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=ppjgJqYX7luzeTBm+drLJ9vuFgo85lRZNGVMyr8ao4o=;
 b=CCoOY8y/CNRkJFfr8BH7K4sZ7rXYF3/x1Aaj4EFNn9KOAt4ZPaMHF+e0pjDZBxW2uoOa
 YKsFasbLmgPD7Qx8x82QoOcKrgRDkI0+KurqdDvujFKSCP5Z0jnvuF4+FWGbx5D9B+5l
 KDtOJ//+0WRqp4tz5JDnbQMhWwEzb6WYrjdjZDQDwkWrfluk5kTqaW/l/SC8KakpkJjV
 tvkdO+OMn0WMMgk9tOq7HgZH3PgwTo/327+dO9Ae0QoQXSy8Fb8OIMQXsYzLZXMJowPz
 tr7aL3UKGcd7GepYRD/Hlm3B3uxLv3TCfsdjGKm9Iec648h4XivodxZ+GP2gpbn4HmQF iQ== 
Received: from rn-mailsvcp-mta-lapp01.rno.apple.com (rn-mailsvcp-mta-lapp01.rno.apple.com [10.225.203.149])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 33t4mv9u7b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 30 Sep 2020 10:55:43 -0700
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) with ESMTPS id <0QHH00N3GGGUWV50@rn-mailsvcp-mta-lapp01.rno.apple.com>;
 Wed, 30 Sep 2020 10:55:42 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QHH00V00GFB8O00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Wed,
 30 Sep 2020 10:55:42 -0700 (PDT)
X-Va-CD: 0
X-Va-ID: 597b9d12-f48c-4b99-95d8-2781260221f2
X-V-A:  
X-V-T-CD: a7df34be26ac7dd9260bc16392ad79bf
X-V-E-CD: 2a4a1dd8f75d88b6e628a9a0f9d97b7a
X-V-R-CD: 386069bd7ecc60f5449d4e168f573c48
X-V-CD: 0
X-V-ID: d3cd4b07-1f59-434e-9196-f74cd65788be
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
Received: from [17.149.214.207] (unknown [17.149.214.207])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QHH00UL6GGQPM00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Wed,
 30 Sep 2020 10:55:38 -0700 (PDT)
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Forgue <andrewf@apple.com>
From:   Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Subject: vsock fix backport to 5.4 stable
Message-id: <0c41f301-bedf-50be-d233-25d0d98b64ca@apple.com>
Date:   Wed, 30 Sep 2020 10:55:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Can we have this backport applied to 5.4 stable, its a useful fix.

commit df12eb6d6cd920ab2f0e0a43cd6e1c23a05cea91 upstream

The call has a minor api change in 5.4 vs higher, only the pkt arg is 
required.

diff --git a/net/vmw_vsock/virtio_transport_common.c 
b/net/vmw_vsock/virtio_transport_common.c
index d9f0c9c5425a..2f696124bab6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1153,6 +1153,7 @@ void virtio_transport_recv_pkt(struct 
virtio_transport *t,
          virtio_transport_free_pkt(pkt);
          break;
      default:
+        (void)virtio_transport_reset_no_sock(pkt);
          virtio_transport_free_pkt(pkt);
          break;
      }
-- 
