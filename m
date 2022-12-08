Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BBB6475F3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLHTHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLHTHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:07:13 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561B28F096
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:07:12 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id fy4so2175729pjb.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XCQxkSX68wqC+xYZ6HcQAhvyVD70BBTOb/sZXInwVAc=;
        b=l+5tyS5BrFG6cf5CmXiStrreFA3TGHQ36+ParPAf3rG87vze/JHPDMtR7EeTQeNR94
         yguiOl7brDY/rJc5yv5m2NledHuTzRUTXwpT+ORLysWopKGEwDQovasRrU7iGqzYBBpY
         YKOtN+ifQPRa4bj4DjVNCA+WlZkxACeBckdHvlmdgmxTRSrVNbUe+G/FvopjcvWL8Llh
         iPm3428sT5eSj5S1GLBTuq1azMha4EP3hQKvitB4+dRpHw8dXSA/zoMWf+6yZycKQ2Qn
         ATEwbWyIlXNWS1+w4Y2MRJh/DniR1bUjRLvuzKXCtmuMxWY6qcWlrpo1YEmdt1lTm3T5
         5J2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCQxkSX68wqC+xYZ6HcQAhvyVD70BBTOb/sZXInwVAc=;
        b=URHzRTSwQczZbB96ER8OLduCBePJoxTNHrD3R+Lwv8WgLyLclIHeCdIcqFuqIx+ctw
         UXv96jF9dZnVLTSYuk/uLx5pWDB/LRGYHSyGZULQSODVCyqbCMy2wE8saqtYIZn+oE1+
         EY+zniQfE+bPf8zM2WnhjDsgIYcm615DemeTtknEA0Huog+0mM9M2s2IVu0m6u+7vHFE
         Xj3j1pdRq37YFHpCbe0eqxuKhXQzJbubDMO7f5eCkv759tJTBONVScWNuQcyZkQIKwii
         L0RXZCS57K/dghydE/N32T9r3i5Lte5SPP82tIc+UilCdePPQqZ+LpTukl2svKbSHnse
         mm0w==
X-Gm-Message-State: ANoB5pmndC/bKE3a04OT1AXGwnUAT6Z22BqaYir/aR+BSPpShcFYhBFt
        XeCsbwZb5FSqD4kgCFyBOU9HjGRzGQfqGCNfORU3dg==
X-Google-Smtp-Source: AA0mqf7GaWTmzlI1QGFsZj/CjVKeCEsobuxFLQxykjospoKh+9QAVnRypOnNrGnI2H6/m62ad0FEPf3+7rh6Jigf0gM=
X-Received: by 2002:a17:902:d711:b0:188:c7b2:2dd with SMTP id
 w17-20020a170902d71100b00188c7b202ddmr79046589ply.88.1670526431719; Thu, 08
 Dec 2022 11:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-2-sdf@google.com>
 <20221207202559.4d507ccf@kernel.org>
In-Reply-To: <20221207202559.4d507ccf@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 11:06:59 -0800
Message-ID: <CAKH8qBspJSHDVDMs+zo5G6g8r6VjS3KUeZoh4ik0k9UghYNXqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 01/12] bpf: Document XDP RX metadata
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 8:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  5 Dec 2022 18:45:43 -0800 Stanislav Fomichev wrote:
> > +- ``bpf_xdp_metadata_rx_timestamp_supported`` returns true/false to
> > +  indicate whether the device supports RX timestamps
> > +- ``bpf_xdp_metadata_rx_timestamp`` returns packet RX timestamp
> > +- ``bpf_xdp_metadata_rx_hash_supported`` returns true/false to
> > +  indicate whether the device supports RX hash
> > +- ``bpf_xdp_metadata_rx_hash`` returns packet RX hash
>
> Would you mind pointing to the discussion about the separate
> _supported() kfuncs? I recall folks had concerns about the function
> call overhead, and now we have 2 calls per field? :S

Take a look at [0] and [1]. I'm still assuming that we might support
some restricted set of kfuncs that can be unrolled so keeping this
simple/separate apis.

0: https://lore.kernel.org/bpf/CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com
1: https://lore.kernel.org/bpf/Y4XZkZJHVvLgTIk9@lavr/
