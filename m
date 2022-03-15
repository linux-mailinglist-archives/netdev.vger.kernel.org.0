Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035BF4D93EA
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344875AbiCOFeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344876AbiCOFeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:34:18 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DA060ED;
        Mon, 14 Mar 2022 22:33:05 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j29so12593586ila.4;
        Mon, 14 Mar 2022 22:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VpoDEU/mWGmGEdjxwMsgpnfFjrvrmw3U8imrYuvmorM=;
        b=mRNynIVKElGyBOJglKvSeBbPY4tJuikLW+gVh4+PVfSTtiDBJ4jnYIGSYuZjIkBRn0
         pck23SCyXOHiXpU/yfM9CxAcYvoSdWwJXCnKlWEOsx5kcRgFlPADnWMEx+LUnf79opg5
         ZSANmY8UzNe3LjuHZ1z04Gi/9H/LBmNTvPjsCOb6XCbeanYsGVza3f4tY5GBdFeg6PdI
         LvrDljrutuP4bBqKuyGYkRVn8uFITYR9yPXTPM24tiGvGR+U1WERSW6uGj8A3OBa0Xls
         nv2fkPZVAtvcpwR4SRyGtDPVOsfz2VMhyoW7KznrrYmhttnMfiKOtEh2rt29INJGFxPC
         TLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VpoDEU/mWGmGEdjxwMsgpnfFjrvrmw3U8imrYuvmorM=;
        b=uBhnknto7lp9I6szNsLhMPbz9awXNP1PK+kCWNT5gzS3QsJpsHmcIPhWux9OWuZDEy
         ctDqGoa/Gri8vNokIlBu36BUGlfJv/8sgvSXy9qAgXCS19t2maXQAejvrK7JGQgvbu65
         O7RX3RxnZTWLJ1Qk68NgeFQyFmFZPwQL8aBsxtvD8PO7IrY0aKBdgXhiSVnRjUPLfXub
         RL1pvXclBrDQnjWKTouXC9Y1cK6Ws5BTOfTP7LZh8k7lnpMFdnYOLh4uRi/3A0Ux6Od0
         WzDGYUDSjG93+iKl9FbC27yrK+zlbKB/FfDdpydx7IBjKe1zU1iyPYiubp/1qqbXZY3N
         ywbw==
X-Gm-Message-State: AOAM531LcS3pIU5iqCbse7GjYDXSnmON43m+dH8wzWOf37BFsWP70ZbD
        e4SDsOPaEHfzSlZlLkErypg=
X-Google-Smtp-Source: ABdhPJzAje9jLdysYFZvhxi4vr2d1JTTu4Bg7WUQ+94KSHY2uM1L9QzAduBIwYeHPAlisLgdQ7vIOg==
X-Received: by 2002:a05:6e02:684:b0:2c6:3cc5:e83b with SMTP id o4-20020a056e02068400b002c63cc5e83bmr21409112ils.91.1647322385428;
        Mon, 14 Mar 2022 22:33:05 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id l14-20020a056e0205ce00b002c782f5e905sm5871199ils.74.2022.03.14.22.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 22:33:05 -0700 (PDT)
Date:   Mon, 14 Mar 2022 22:32:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Message-ID: <62302509c2ca6_1301920891@john.notmuch>
In-Reply-To: <b751d5324b772a7655635b0f516e0a4cf50529db.1646755129.git.lorenzo@kernel.org>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <b751d5324b772a7655635b0f516e0a4cf50529db.1646755129.git.lorenzo@kernel.org>
Subject: RE: [PATCH v4 bpf-next 1/3] net: veth: account total xdp_frame len
 running ndo_xdp_xmit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Even if this is a theoretical issue since it is not possible to perform
> XDP_REDIRECT on a non-linear xdp_frame, veth driver does not account
> paged area in ndo_xdp_xmit function pointer.
> Introduce xdp_get_frame_len utility routine to get the xdp_frame full
> length and account total frame size running XDP_REDIRECT of a
> non-linear xdp frame into a veth device.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
