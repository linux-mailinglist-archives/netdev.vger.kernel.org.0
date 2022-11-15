Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F0B629EBE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbiKOQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbiKOQRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:17:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08EE29803
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668528981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HkZJo7ihz1szHJ/yv2XMHuZBo+vyRhbr4deHvof0O2I=;
        b=hdPMoO0Pg3zBSxohiRCe0o4TRfVyYm2w2OwXbnV2bDdPbPd1JwzJnFgKIb8qlZs15bYaVj
        UiSVhp5NlFnfXAnDZN+4zPyhCTpjlawavItXSlnMdMr73LjvHEcjNb0W7xEjr50yU/ZV9B
        /SsKNSBAk3H/KRaS7FxRDhXw8w7iYio=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-527-5g5DDc51P1aCkyvlZWGELQ-1; Tue, 15 Nov 2022 11:16:19 -0500
X-MC-Unique: 5g5DDc51P1aCkyvlZWGELQ-1
Received: by mail-ed1-f72.google.com with SMTP id h9-20020a05640250c900b00461d8ee12e2so10341333edb.23
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:16:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HkZJo7ihz1szHJ/yv2XMHuZBo+vyRhbr4deHvof0O2I=;
        b=fj/TzPSc5hVj/mXIeotoq5dyVEe/wQC0nQS9XxHtbSxsXiW7EgCVHVA8svhlx71GKt
         RSGGsjWbGL9S7Yh2mUDcHewSAJstNNUc4rWfv2j7iSC1Gjp7xHpTPOHdvQYWyho+0nXg
         nLatOVD7igsm9rDJh8An/z/xOqaS6r/txqsyA+V1+K30oHWcFzBwbiYHxcxbqmJWDdqj
         RygRi6ZiMnXiZlsbbERsTVUC9St520G18tIsn+PeIef9793WIGrZ80AL4BajzurC36Ty
         sDwQHZKcasfGuA9XJqiZhkbmpOK43H3MwvlHRPbOPc2vhDjWMgUkXBxjmuFmYvoOIzpD
         tKUA==
X-Gm-Message-State: ANoB5pkLVOIARN4lWuyzHrtMannXumcV3gIXCPVymjXMdQPkJH9vlAqC
        QvcKbLpcT+TD+qOEoxaNJQcF1jgV0N9MI8LwCzA90orcWKXruhdBY1/3piHtTjzj8SnRf9C3RJv
        z1jpxM1genpphqQhM
X-Received: by 2002:a17:906:ae8b:b0:7ad:9892:921a with SMTP id md11-20020a170906ae8b00b007ad9892921amr14061878ejb.506.1668528978348;
        Tue, 15 Nov 2022 08:16:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7gXgx9VFbUvzjVWuFoOBHoSx0oOky+qIcQjKi0O0nvDDk9+CQ6VrGUp4tMnhYlPK1u6drfWQ==
X-Received: by 2002:a17:906:ae8b:b0:7ad:9892:921a with SMTP id md11-20020a170906ae8b00b007ad9892921amr14061856ejb.506.1668528978086;
        Tue, 15 Nov 2022 08:16:18 -0800 (PST)
Received: from [10.39.192.204] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id b19-20020aa7df93000000b004587f9d3ce8sm6259025edy.56.2022.11.15.08.16.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 08:16:17 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>, dev@openvswitch.org
Subject: Patch "openvswitch: Fix Frame-size larger than 1024 bytes warning"
 not correct.
Date:   Tue, 15 Nov 2022 17:16:15 +0100
X-Mailer: MailMate (1.14r5927)
Message-ID: <9FD6F4CD-4F41-4350-B217-4EFE40E347E2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

It looks like a previous fix you made, 190aa3e77880 ("openvswitch: Fix Fr=
ame-size larger than 1024 bytes warning."), is breaking stuff. With this =
change, the actual flow lookup, ovs_flow_tbl_lookup(), is done using a ma=
sked key, where it should be an unmasked key. This is maybe more clear if=
 you take a look at the diff for the ufid addition, 74ed7ab9264c ("openvs=
witch: Add support for unique flow IDs.").

Just reverting the change gets rid of the problem, but it will re-introdu=
ce the larger stack size. It looks like we either have it on the stack or=
 dynamically allocate it each time. Let me know if you have any other cle=
ver fix ;)

We found this after debugging some customer-specific issue. More details =
are in the following OVS patch, https://patchwork.ozlabs.org/project/open=
vswitch/list/?series=3D328315

Cheers,

Eelco


FYI the working revers:


   Revert "openvswitch: Fix Frame-size larger than 1024 bytes warning."

    This reverts commit 190aa3e77880a05332ea1ccb382a51285d57adb5.

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 861dfb8daf4a..660d5fdd9b28 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, stru=
ct genl_info *info)
        struct sw_flow_mask mask;
        struct sk_buff *reply;
        struct datapath *dp;
+       struct sw_flow_key key;
        struct sw_flow_actions *acts;
        struct sw_flow_match match;
        u32 ufid_flags =3D ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FL=
AGS]);
@@ -975,24 +976,20 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
        }

        /* Extract key. */
-       ovs_match_init(&match, &new_flow->key, false, &mask);
+       ovs_match_init(&match, &key, true, &mask);
        error =3D ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
                                  a[OVS_FLOW_ATTR_MASK], log);
        if (error)
                goto err_kfree_flow;

+       ovs_flow_mask_key(&new_flow->key, &key, true, &mask);
+
        /* Extract flow identifier. */
        error =3D ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_U=
FID],
-                                      &new_flow->key, log);
+                                      &key, log);
        if (error)
                goto err_kfree_flow;

-       /* unmasked key is needed to match when ufid is not used. */
-       if (ovs_identifier_is_key(&new_flow->id))
-               match.key =3D new_flow->id.unmasked_key;
-
-       ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
-
        /* Validate actions. */
        error =3D ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
                                     &new_flow->key, &acts, log);
@@ -1019,7 +1016,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
        if (ovs_identifier_is_ufid(&new_flow->id))
                flow =3D ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->=
id);
        if (!flow)
-               flow =3D ovs_flow_tbl_lookup(&dp->table, &new_flow->key);=

+               flow =3D ovs_flow_tbl_lookup(&dp->table, &key);
        if (likely(!flow)) {
                rcu_assign_pointer(new_flow->sf_acts, acts);

