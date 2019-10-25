Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B2CE443E
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406760AbfJYHTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:19:02 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45204 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733140AbfJYHTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:19:01 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so926486pgj.12;
        Fri, 25 Oct 2019 00:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FkSDn5KxWB0OA8DzTKMRxKr6IBPdsqPwb0nb2bPS14=;
        b=ANznHP9cZqICAlgei46L0uQIvhy5V2xZs2Hcwc6DClSKSNG97nTKhIICGs/k9fpwW0
         1Eczy2TDDXQoBlUohhzDJ/B2CV7dPqfDVdmEdIZfS7auZefEtL9KkDPtV+SegHnliHXb
         NqMIOYcacdP0RyUMYwjescgzbl2PLV9/gE/46xuuLraGD56o4SpKwQcsI7iYW02iuMPy
         JGoQAmL1NulMEwFEugRqTVTyfMkXZWEkq7uHzevKjbvMFodz+CjAdGB0l0OWwEHX6Jik
         HrmcEaav4ux/PdtrAiZd5O3g1u0KOqeehEhqmBvTWLBaTDAlpBho+fW3FOHL+Ldgdx+B
         BU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FkSDn5KxWB0OA8DzTKMRxKr6IBPdsqPwb0nb2bPS14=;
        b=iMciCn6+R62fcPAmA11XZoD0+26plqhqqfWf3nbW7G/4zfuih0Q+nSPK4a33CQsUjr
         K28ZgQif1Xu7Jo/YmewYwSyw/+NazHlbHJgsjfTXJoYbTHIHXg8TxKcAcdrnw9MrpGyW
         /ZiPzjiP+WnSbYg+f7FdsV5lkR6yL+9ScNC2n9MIaAmoWErlHBBpfRxE4D1XztlMiT9v
         pvkgsLwvxkA3IBWoqAdPiyz7EU1302OJNt/Z37cLu5crI8EuUt5eIiHd5PLoaKH1SODt
         bHeQUS4cZ/Afr4KG2JFZxOPgeFSW2pqTuLuM93zUfF5offSRiy2LJGLShH7vju1Jv0xf
         u4Vg==
X-Gm-Message-State: APjAAAXO2tdCepAJF2ygc4tNe9PtnupZPWmBTyW1ZvJEsAfcThYX2UJq
        OiPDqtuJtaNrYaXtPTzvfVFpu8JbTfA=
X-Google-Smtp-Source: APXvYqxOg5k7FmVI4YN3eqoYHqnhhoI84rxFyZDHsG/vXX9axkZpOP0euclDuDBBRMHiLQZX2hzp+w==
X-Received: by 2002:a63:ab49:: with SMTP id k9mr179745pgp.34.1571987940114;
        Fri, 25 Oct 2019 00:19:00 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t27sm1165065pfq.169.2019.10.25.00.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 00:18:59 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        toke@redhat.com
Subject: [PATCH bpf-next v2 0/2] xsk: XSKMAP lookup improvements
Date:   Fri, 25 Oct 2019 09:18:39 +0200
Message-Id: <20191025071842.7724-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small set consists of two patches from Maciej and myself which
are optimizing the XSKMAP lookups.  In the first patch, the sockets
are moved to be stored at the tail of the struct xsk_map. The second
patch, Maciej implements map_gen_lookup() for XSKMAP.

Based on the XDP program from tools/lib/bpf/xsk.c where
bpf_map_lookup_elem() is explicitly called, this work yields the 5%
improvement for xdpsock's rxdrop scenario.

Cheers,
Björn and Maciej

v1->v2: * Change size/cost to size_t and use {struct, array}_size
          where appropriate. (Jakub)

Björn Töpel (1):
  xsk: store struct xdp_sock as a flexible array member of the XSKMAP

Maciej Fijalkowski (1):
  bpf: implement map_gen_lookup() callback for XSKMAP

 kernel/bpf/xskmap.c | 72 +++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 32 deletions(-)

-- 
2.20.1

