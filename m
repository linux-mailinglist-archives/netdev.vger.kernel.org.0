Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2A1E932F
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgE3SuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 14:50:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729183AbgE3SuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 14:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590864601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=++RjQVfu0ozeBaKm8cqT4cx4Oo3ih1rp0xAXUCbBDRM=;
        b=Q+Jc8zUn2zKEzVDuthCMOGnb5bhwJ/a03LkYBqL2DppK5Z1Ny8pcVYumMLVMc02D31GR4R
        VkbLTVJ582zEc9TuEJ8Jf7zGtEDMbBWfJMOZbG899+LgB3QUdp+ZFWLt1zojcTxVwGowk1
        SQFY/XzwQW7oPJWFfy/wX1I9h/f1ml0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-rvDngL_eOsK44kjjZ8m-Dg-1; Sat, 30 May 2020 14:50:00 -0400
X-MC-Unique: rvDngL_eOsK44kjjZ8m-Dg-1
Received: by mail-wr1-f70.google.com with SMTP id m14so674502wrj.12
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 11:50:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=++RjQVfu0ozeBaKm8cqT4cx4Oo3ih1rp0xAXUCbBDRM=;
        b=qPiW1NYWoKXkBwvidi4gE0yuUYLYRduuZWY9xR1J7oRA9AJNF5DN0mn1bXpZwiEPb+
         an3G3yjslboduyzFjJW6gUMWwO8Es7akmBCiZUgXRiLlQqoAZl5j044tSBYhsMavbx3S
         Z6R0mPICK8PkjBrTd3cY/W0UYHSx+d7ZS0sys0iRAogkIs4VMKS2hg0w4+YLfWiLP9nI
         Y/Iu01t2IRr7sQIiFRMdYIZ6R2vavvF/aWK+CF8+veFeFl/kUWxY7OgWL3VrwtRrkrNB
         T4psscz/x46ZQe5BDyBijXz9R1mujcRbZe2PK/ybSd1hxDA4CbGap5gGbk1X465mcaSK
         RWhw==
X-Gm-Message-State: AOAM531x8Z6xGC4YvvTa6C52D2mm0VnZInKfNWd7Zwo5DF7dcmdYECxl
        Xmb2G325U2L3mXAmUAHD7SLDRt1PKxIEf2ySTx0PpMcCvm62YEpQ6puMnZSH90o+eTcByhwRYya
        V5YjX597M1PF0wxbt
X-Received: by 2002:a05:6000:1146:: with SMTP id d6mr14091727wrx.400.1590864598925;
        Sat, 30 May 2020 11:49:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz3t1rXDrTrjyrTyzt68O/OaU/uEX9V0XywBP2nK2MQIJs8KUoK6POfr6mWfLuUyqgIp+hhA==
X-Received: by 2002:a05:6000:1146:: with SMTP id d6mr14091710wrx.400.1590864598701;
        Sat, 30 May 2020 11:49:58 -0700 (PDT)
Received: from pc-3.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id s2sm4319841wmh.11.2020.05.30.11.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 11:49:58 -0700 (PDT)
Date:   Sat, 30 May 2020 20:49:56 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] cls_flower: remove mpls_opts_policy
Message-ID: <4158adb2a6a49cd652f3ad47d59f2a976b6c1d18.1590864517.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compiling with W=1 gives the following warning:
net/sched/cls_flower.c:731:1: warning: ‘mpls_opts_policy’ defined but not used [-Wunused-const-variable=]

The TCA_FLOWER_KEY_MPLS_OPTS contains a list of
TCA_FLOWER_KEY_MPLS_OPTS_LSE. Therefore, the attributes all have the
same type and we can't parse the list with nla_parse*() and have the
attributes validated automatically using an nla_policy.

fl_set_key_mpls_opts() properly verifies that all attributes in the
list are TCA_FLOWER_KEY_MPLS_OPTS_LSE. Then fl_set_key_mpls_lse()
uses nla_parse_nested() on all these attributes, thus verifying that
they have the NLA_F_NESTED flag. So we can safely drop the
mpls_opts_policy.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/cls_flower.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 96f5999281e0..8f010cff03a6 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -727,11 +727,6 @@ erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
 };
 
-static const struct nla_policy
-mpls_opts_policy[TCA_FLOWER_KEY_MPLS_OPTS_MAX + 1] = {
-	[TCA_FLOWER_KEY_MPLS_OPTS_LSE]    = { .type = NLA_NESTED },
-};
-
 static const struct nla_policy
 mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
 	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
-- 
2.21.1

