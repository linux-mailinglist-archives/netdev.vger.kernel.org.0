Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A82013CD4E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgAOTnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:43:32 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:46383 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgAOTnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:43:31 -0500
Received: by mail-pl1-f178.google.com with SMTP id y8so7244582pll.13;
        Wed, 15 Jan 2020 11:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Atrc4M+lXKJWelgGLCJ59DSdh2EROfwZs1v02Dm2Dso=;
        b=idEmVS+HLIAuQW46Bc4UwAAedJAyx3ywzMWLMxOW7Sjs3OT1PKHGc1Vs5LPvgqwzJV
         zhRtaN+zouEcj+HEsqMPlSphvDzWuArZNjXYfH6u/O6mxbeoX+kiJmW7SyJG2wsswPGE
         Az8iszlXuR9GepFyFqXO9LEV3GR5/3EubQIxxxScmmjV4Vrz6QWn/4JZgXO022c0Rt5E
         mllAAbYg0K4wx/YBt5PEa7m3AlHtPzNIMlhQRQ3C1FFCrgw4pzWkEICKM3oYW07XIbX8
         E1uiqwBkP9YicfdUwL/3KIZZnxIcwMmg6xxAlAj6XBnC5/6fJwYsBhgsBTSn4PDQa8cx
         ttrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Atrc4M+lXKJWelgGLCJ59DSdh2EROfwZs1v02Dm2Dso=;
        b=CXE7EZ68retcPADlABZVZwxTJT82BZuOMk+6spImtlC8q3TCFViEH6snAR4rL4KDvb
         SP3kFWsyuJWk0GKFp4s2iin9C4WGlDL6LGwu+FzjUerEKD2DyPbZ4fbTN/Y2n0IiTiD0
         UbxrL01NSzANMrPXVgQrzECAI99cBzehu3OxOJQqKx3TRiUYDE8o/Z0gEYg9Z5L1AvXP
         7AXMYT6qsbPS/E92a8wgksd+2iQh3iA3VZlyRdI0I/l/xxBwu6Ii7G9C+11G+kJ9deVA
         vevL/maPb9e1vxrRy5Hf/coO5eK3ft7PIppwYiAq8bFdKJhwop8YpkEJcblFKIMovtPX
         ip5A==
X-Gm-Message-State: APjAAAWk5nKiwB9PyxAlfbG+VQ1XizhbP/fhF+vfHXv5tdskAWL4j6gu
        kBenhR/WcAqYcTBuujC0Vbw=
X-Google-Smtp-Source: APXvYqwpBaCtvOuxXhHNrBBQqAlszhopj4+SyjAoiRjirw9lGKYBjO0N+6365iHKU0DuW8Ma3WF6WQ==
X-Received: by 2002:a17:902:6ac3:: with SMTP id i3mr27761026plt.111.1579117411161;
        Wed, 15 Jan 2020 11:43:31 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id h7sm23992205pfq.36.2020.01.15.11.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 11:43:30 -0800 (PST)
Date:   Wed, 15 Jan 2020 11:43:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e1f6b61c9d74_72f02acbae15e5c460@john-XPS-13-9370.notmuch>
In-Reply-To: <157893905677.861394.8918679692049579682.stgit@toke.dk>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk>
 <157893905677.861394.8918679692049579682.stgit@toke.dk>
Subject: RE: [PATCH bpf-next v2 2/2] xdp: Use bulking for non-map XDP_REDIRECT
 and consolidate code paths
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> =

> Since the bulk queue used by XDP_REDIRECT now lives in struct net_devic=
e,
> we can re-use the bulking for the non-map version of the bpf_redirect()=

> helper. This is a simple matter of having xdp_do_redirect_slow() queue =
the
> frame on the bulk queue instead of sending it out with __bpf_tx_xdp().
> =

> Unfortunately we can't make the bpf_redirect() helper return an error i=
f
> the ifindex doesn't exit (as bpf_redirect_map() does), because we don't=

> have a reference to the network namespace of the ingress device at the =
time
> the helper is called. So we have to leave it as-is and keep the device
> lookup in xdp_do_redirect_slow().
> =

> Since this leaves less reason to have the non-map redirect code in a
> separate function, so we get rid of the xdp_do_redirect_slow() function=

> entirely. This does lose us the tracepoint disambiguation, but fortunat=
ely
> the xdp_redirect and xdp_redirect_map tracepoints use the same tracepoi=
nt
> entry structures. This means both can contain a map index, so we can ju=
st
> amend the tracepoint definitions so we always emit the xdp_redirect(_er=
r)
> tracepoints, but with the map ID only populated if a map is present. Th=
is
> means we retire the xdp_redirect_map(_err) tracepoints entirely, but ke=
ep
> the definitions around in case someone is still listening for them.
> =

> With this change, the performance of the xdp_redirect sample program go=
es
> from 5Mpps to 8.4Mpps (a 68% increase).
> =

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: John Fastabend <john.fastabend@gmail.com>=
