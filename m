Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373DF30DBBE
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhBCNtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhBCNsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 08:48:12 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494B0C061786
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 05:47:31 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id v24so33397710lfr.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 05:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6PNw3lVRfKE6wx9hIHIMzibL3O4FJ16IElvKleWr4c=;
        b=C2+K92tdQSBUUPpBUQ2xbckAoVttnUB23UCXCyV02ahxSaj3XbOQUSFAVIUV+76sNl
         TyahvgE5ukew4UqACe7/sw8v/vA4l7ZttdLIEwmkFom9GiDMMkRNoioxAhGtv1vOYVM3
         uXIRNXUZ3uqV+F8bnmE4OkqR1WonjSCJ40prHsxF39/Sx4P8hDWrk01FOTt+H/j2zwMs
         39pEULCrZ4QXpb5+EqqfB7SRFKKH8RuXGi+wC1LQT3iUXrKHwyLZZPcPuUyE29AwcfZJ
         w/m3BPLFXXrbvr9pRoA8/jm755QCE/RSnoV/IaLgJsLaftW+TT1TGQnU1ziV9nktlNrW
         Qy1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6PNw3lVRfKE6wx9hIHIMzibL3O4FJ16IElvKleWr4c=;
        b=pokBzLgQmczrCSEIwfwtazT2KEi3a2ywuJ6EbCMv1RJLnKRukEOdf7RbAlBpbG/ST2
         D7aYbXtFK+rQJGM4ehsm1DfyITbt9feMbORp8xM1YWyw1xqlzmCnWl8jDBILSuSujaOE
         aCLLImOz9h6L9F9utOav4j4iG4+4rZkbUWckdcWbThgiiy2jlmv3B9zi5xVo7VSfn9q+
         kYE1S5V88/Vp6ZhkCG0REgXLrbKz4Elw1iXckQU5uW5Q9L3KNxSU77+l3pb28OuWhf6Z
         OvQr0L78yPw8veSA4NPU3YMSeUpTnwoZLZVjjKOk13XZa+4QoEdC4GXcAyg2+y1+HeqZ
         bB2A==
X-Gm-Message-State: AOAM530yth2ign0FqCKglRisM3lIn0Zsvhk85R55LSJb0HNwO8FN5CFy
        /reojv/EnBKqBVjn2Y5Set3IsSig+raDk9RlG6Y=
X-Google-Smtp-Source: ABdhPJwuBefzMu/qfgX3IcWJO+356UGN8TYoj4LrGQjCjWts40funTuu2yhM3VgXjLs/ppQWfUeuHemCCzBwHu+ukKc=
X-Received: by 2002:a19:545:: with SMTP id 66mr1798135lff.136.1612360049788;
 Wed, 03 Feb 2021 05:47:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611637639.git.lucien.xin@gmail.com> <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com>
 <645990.1612339208@warthog.procyon.org.uk> <CADvbK_dJJjiQK+N0U04eWCU50DRbFLNqHSi7Apj==d3ygzkz6g@mail.gmail.com>
 <655776.1612343656@warthog.procyon.org.uk>
In-Reply-To: <655776.1612343656@warthog.procyon.org.uk>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Feb 2021 21:47:18 +0800
Message-ID: <CADvbK_ePdoJRna81YwJUL5cqu1ST3W8J8kRqhbNVGdSse-3u1w@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4
 packets with UDP GRO
To:     David Howells <dhowells@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        vfedorenko@novek.ru
Content-Type: multipart/mixed; boundary="000000000000049f2505ba6ed4a3"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000049f2505ba6ed4a3
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 3, 2021 at 5:14 PM David Howells <dhowells@redhat.com> wrote:
>
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > BTW, I'm also thinking to use udp_sock_create(), the only problem I can
> > see is it may not do bind() in rxrpc_open_socket(), is that true? or we
> > can actually bind to some address when a local address is not supplied?
>
> If a local address isn't explicitly bound to the AF_RXRPC socket, binding the
> UDP socket to a random local port is fine.  In fact, sometimes I want to
> explicitly bind an rxrpc server socket to a random port.  See fs/afs/rxrpc.c
> function afs_open_socket():
>
>         /* bind the callback manager's address to make this a server socket */
>         memset(&srx, 0, sizeof(srx));
>         srx.srx_family                  = AF_RXRPC;
>         srx.srx_service                 = CM_SERVICE;
>         srx.transport_type              = SOCK_DGRAM;
>         srx.transport_len               = sizeof(srx.transport.sin6);
>         srx.transport.sin6.sin6_family  = AF_INET6;
>         srx.transport.sin6.sin6_port    = htons(AFS_CM_PORT);
>         ...
>         ret = kernel_bind(socket, (struct sockaddr *) &srx, sizeof(srx));
>         if (ret == -EADDRINUSE) {
>                 srx.transport.sin6.sin6_port = 0;
>
>                 ^^^ That's hoping to get a random port bound.
>
>                 ret = kernel_bind(socket, (struct sockaddr *) &srx, sizeof(srx));
>         }
>         if (ret < 0)
>                 goto error_2;
>
> The client cache manager server socket here is used to receive notifications
> back from the fileserver.  There's a standard port (7001) for the service, but
> if that's in use, we can use any other port.  The fileserver grabs the source
> port from incoming RPC requests - and then uses that when sending 3rd-party
> change notifications back.
>
> If you could arrange for a random port to be assigned in such a case (and
> indicated back to the caller), that would be awesome.  Possibly I just don't
> need to actually use bind in this case.
>
The patch is attached (based on this patch):

+       udp_conf.family = srx->transport.family;
+       if (udp_conf.family == AF_INET) {
+               udp_conf.local_ip = srx->transport.sin.sin_addr;
+               udp_conf.local_udp_port = srx->transport.sin.sin_port;
+       } else {
+               udp_conf.local_ip6 = srx->transport.sin6.sin6_addr;
+               udp_conf.local_udp_port = srx->transport.sin6.sin6_port;
+       }
+       ret = udp_sock_create(net, &udp_conf, &local->socket);

I think this will work well. When the socket is not bound,
srx->transport.sin.sin(6)_addr/sin(6)_port are zero. It'll
bind to a random port in udp_sock_create().

BTW: do you have any testing for this?

Thanks.

--000000000000049f2505ba6ed4a3
Content-Type: application/octet-stream; 
	name="0001-rxrpc-use-udp-tunnel-APIs-instead-of-open-code-in-rx.patch"
Content-Disposition: attachment; 
	filename="0001-rxrpc-use-udp-tunnel-APIs-instead-of-open-code-in-rx.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkphbrnb0>
X-Attachment-Id: f_kkphbrnb0

RnJvbSA1NzQ4ZDYzMTJhZDgwMjVmNmUzNDdhMGIwNjdiMjA0MzIwYjFjNzcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NTc0OGQ2MzEyYWQ4MDI1ZjZlMzQ3YTBiMDY3YjIw
NDMyMGIxYzc3MC4xNjEyMzU5MDQzLmdpdC5sdWNpZW4ueGluQGdtYWlsLmNvbT4KRnJvbTogWGlu
IExvbmcgPGx1Y2llbi54aW5AZ21haWwuY29tPgpEYXRlOiBXZWQsIDMgRmViIDIwMjEgMDg6MjU6
MjggLTA1MDAKU3ViamVjdDogW1BBVENIIG5ldC1uZXh0XSByeHJwYzogdXNlIHVkcCB0dW5uZWwg
QVBJcyBpbnN0ZWFkIG9mIG9wZW4gY29kZSBpbgogcnhycGNfb3Blbl9zb2NrZXQKClNpZ25lZC1v
ZmYtYnk6IFhpbiBMb25nIDxsdWNpZW4ueGluQGdtYWlsLmNvbT4KLS0tCiBuZXQvcnhycGMvbG9j
YWxfb2JqZWN0LmMgfCA2OSArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgNDUgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvbmV0L3J4cnBjL2xvY2FsX29iamVjdC5jIGIvbmV0L3J4cnBjL2xvY2FsX29iamVj
dC5jCmluZGV4IDMzYjQ5MzY3ZDU3NS4uNTQ2ZmQyMzdhNjQ5IDEwMDY0NAotLS0gYS9uZXQvcnhy
cGMvbG9jYWxfb2JqZWN0LmMKKysrIGIvbmV0L3J4cnBjL2xvY2FsX29iamVjdC5jCkBAIC0xMDcs
NTQgKzEwNyw0MiBAQCBzdGF0aWMgc3RydWN0IHJ4cnBjX2xvY2FsICpyeHJwY19hbGxvY19sb2Nh
bChzdHJ1Y3QgcnhycGNfbmV0ICpyeG5ldCwKICAqLwogc3RhdGljIGludCByeHJwY19vcGVuX3Nv
Y2tldChzdHJ1Y3QgcnhycGNfbG9jYWwgKmxvY2FsLCBzdHJ1Y3QgbmV0ICpuZXQpCiB7CisJc3Ry
dWN0IHVkcF90dW5uZWxfc29ja19jZmcgdHVuY2ZnID0ge05VTEx9OworCXN0cnVjdCBzb2NrYWRk
cl9yeHJwYyAqc3J4ID0gJmxvY2FsLT5zcng7CisJc3RydWN0IHVkcF9wb3J0X2NmZyB1ZHBfY29u
ZiA9IHswfTsKIAlzdHJ1Y3Qgc29jayAqdXNrOwogCWludCByZXQ7CiAKIAlfZW50ZXIoIiVweyVk
LCVkfSIsCi0JICAgICAgIGxvY2FsLCBsb2NhbC0+c3J4LnRyYW5zcG9ydF90eXBlLCBsb2NhbC0+
c3J4LnRyYW5zcG9ydC5mYW1pbHkpOwotCi0JLyogY3JlYXRlIGEgc29ja2V0IHRvIHJlcHJlc2Vu
dCB0aGUgbG9jYWwgZW5kcG9pbnQgKi8KLQlyZXQgPSBzb2NrX2NyZWF0ZV9rZXJuKG5ldCwgbG9j
YWwtPnNyeC50cmFuc3BvcnQuZmFtaWx5LAotCQkJICAgICAgIGxvY2FsLT5zcngudHJhbnNwb3J0
X3R5cGUsIDAsICZsb2NhbC0+c29ja2V0KTsKKwkgICAgICAgbG9jYWwsIHNyeC0+dHJhbnNwb3J0
X3R5cGUsIHNyeC0+dHJhbnNwb3J0LmZhbWlseSk7CisKKwl1ZHBfY29uZi5mYW1pbHkgPSBzcngt
PnRyYW5zcG9ydC5mYW1pbHk7CisJaWYgKHVkcF9jb25mLmZhbWlseSA9PSBBRl9JTkVUKSB7CisJ
CXVkcF9jb25mLmxvY2FsX2lwID0gc3J4LT50cmFuc3BvcnQuc2luLnNpbl9hZGRyOworCQl1ZHBf
Y29uZi5sb2NhbF91ZHBfcG9ydCA9IHNyeC0+dHJhbnNwb3J0LnNpbi5zaW5fcG9ydDsKKwl9IGVs
c2UgeworCQl1ZHBfY29uZi5sb2NhbF9pcDYgPSBzcngtPnRyYW5zcG9ydC5zaW42LnNpbjZfYWRk
cjsKKwkJdWRwX2NvbmYubG9jYWxfdWRwX3BvcnQgPSBzcngtPnRyYW5zcG9ydC5zaW42LnNpbjZf
cG9ydDsKKwl9CisJcmV0ID0gdWRwX3NvY2tfY3JlYXRlKG5ldCwgJnVkcF9jb25mLCAmbG9jYWwt
PnNvY2tldCk7CiAJaWYgKHJldCA8IDApIHsKIAkJX2xlYXZlKCIgPSAlZCBbc29ja2V0XSIsIHJl
dCk7CiAJCXJldHVybiByZXQ7CiAJfQogCisJdHVuY2ZnLmVuY2FwX3R5cGUgPSBVRFBfRU5DQVBf
UlhSUEM7CisJdHVuY2ZnLmVuY2FwX3JjdiA9IHJ4cnBjX2lucHV0X3BhY2tldDsKKwl0dW5jZmcu
c2tfdXNlcl9kYXRhID0gbG9jYWw7CisJc2V0dXBfdWRwX3R1bm5lbF9zb2NrKG5ldCwgbG9jYWwt
PnNvY2tldCwgJnR1bmNmZyk7CisKIAkvKiBzZXQgdGhlIHNvY2tldCB1cCAqLwogCXVzayA9IGxv
Y2FsLT5zb2NrZXQtPnNrOwotCWluZXRfc2sodXNrKS0+bWNfbG9vcCA9IDA7Ci0KLQkvKiBFbmFi
bGUgQ0hFQ0tTVU1fVU5ORUNFU1NBUlkgdG8gQ0hFQ0tTVU1fQ09NUExFVEUgY29udmVyc2lvbiAq
LwotCWluZXRfaW5jX2NvbnZlcnRfY3N1bSh1c2spOwotCi0JcmN1X2Fzc2lnbl9za191c2VyX2Rh
dGEodXNrLCBsb2NhbCk7Ci0KLQl1ZHBfc2sodXNrKS0+ZW5jYXBfdHlwZSA9IFVEUF9FTkNBUF9S
WFJQQzsKLQl1ZHBfc2sodXNrKS0+ZW5jYXBfcmN2ID0gcnhycGNfaW5wdXRfcGFja2V0OwotCXVk
cF9zayh1c2spLT5lbmNhcF9kZXN0cm95ID0gTlVMTDsKLQl1ZHBfc2sodXNrKS0+Z3JvX3JlY2Vp
dmUgPSBOVUxMOwotCXVkcF9zayh1c2spLT5ncm9fY29tcGxldGUgPSBOVUxMOwotCi0JdWRwX3R1
bm5lbF9lbmNhcF9lbmFibGUobG9jYWwtPnNvY2tldCk7CiAJdXNrLT5za19lcnJvcl9yZXBvcnQg
PSByeHJwY19lcnJvcl9yZXBvcnQ7CiAKLQkvKiBpZiBhIGxvY2FsIGFkZHJlc3Mgd2FzIHN1cHBs
aWVkIHRoZW4gYmluZCBpdCAqLwotCWlmIChsb2NhbC0+c3J4LnRyYW5zcG9ydF9sZW4gPiBzaXpl
b2Yoc2FfZmFtaWx5X3QpKSB7Ci0JCV9kZWJ1ZygiYmluZCIpOwotCQlyZXQgPSBrZXJuZWxfYmlu
ZChsb2NhbC0+c29ja2V0LAotCQkJCSAgKHN0cnVjdCBzb2NrYWRkciAqKSZsb2NhbC0+c3J4LnRy
YW5zcG9ydCwKLQkJCQkgIGxvY2FsLT5zcngudHJhbnNwb3J0X2xlbik7Ci0JCWlmIChyZXQgPCAw
KSB7Ci0JCQlfZGVidWcoImJpbmQgZmFpbGVkICVkIiwgcmV0KTsKLQkJCWdvdG8gZXJyb3I7Ci0J
CX0KLQl9Ci0KLQlzd2l0Y2ggKGxvY2FsLT5zcngudHJhbnNwb3J0LmZhbWlseSkgeworCXN3aXRj
aCAoc3J4LT50cmFuc3BvcnQuZmFtaWx5KSB7CiAJY2FzZSBBRl9JTkVUNjoKIAkJLyogd2Ugd2Fu
dCB0byByZWNlaXZlIElDTVB2NiBlcnJvcnMgKi8KLQkJaXA2X3NvY2tfc2V0X3JlY3ZlcnIobG9j
YWwtPnNvY2tldC0+c2spOworCQlpcDZfc29ja19zZXRfcmVjdmVycih1c2spOwogCiAJCS8qIEZh
bGwgdGhyb3VnaCBhbmQgc2V0IElQdjQgb3B0aW9ucyB0b28gb3RoZXJ3aXNlIHdlIGRvbid0IGdl
dAogCQkgKiBlcnJvcnMgZnJvbSBJUHY0IHBhY2tldHMgc2VudCB0aHJvdWdoIHRoZSBJUHY2IHNv
Y2tldC4KQEAgLTE2MiwxMyArMTUwLDEzIEBAIHN0YXRpYyBpbnQgcnhycGNfb3Blbl9zb2NrZXQo
c3RydWN0IHJ4cnBjX2xvY2FsICpsb2NhbCwgc3RydWN0IG5ldCAqbmV0KQogCQlmYWxsdGhyb3Vn
aDsKIAljYXNlIEFGX0lORVQ6CiAJCS8qIHdlIHdhbnQgdG8gcmVjZWl2ZSBJQ01QIGVycm9ycyAq
LwotCQlpcF9zb2NrX3NldF9yZWN2ZXJyKGxvY2FsLT5zb2NrZXQtPnNrKTsKKwkJaXBfc29ja19z
ZXRfcmVjdmVycih1c2spOwogCiAJCS8qIHdlIHdhbnQgdG8gc2V0IHRoZSBkb24ndCBmcmFnbWVu
dCBiaXQgKi8KLQkJaXBfc29ja19zZXRfbXR1X2Rpc2NvdmVyKGxvY2FsLT5zb2NrZXQtPnNrLCBJ
UF9QTVRVRElTQ19ETyk7CisJCWlwX3NvY2tfc2V0X210dV9kaXNjb3Zlcih1c2ssIElQX1BNVFVE
SVNDX0RPKTsKIAogCQkvKiBXZSB3YW50IHJlY2VpdmUgdGltZXN0YW1wcy4gKi8KLQkJc29ja19l
bmFibGVfdGltZXN0YW1wcyhsb2NhbC0+c29ja2V0LT5zayk7CisJCXNvY2tfZW5hYmxlX3RpbWVz
dGFtcHModXNrKTsKIAkJYnJlYWs7CiAKIAlkZWZhdWx0OgpAQCAtMTc3LDE1ICsxNjUsNiBAQCBz
dGF0aWMgaW50IHJ4cnBjX29wZW5fc29ja2V0KHN0cnVjdCByeHJwY19sb2NhbCAqbG9jYWwsIHN0
cnVjdCBuZXQgKm5ldCkKIAogCV9sZWF2ZSgiID0gMCIpOwogCXJldHVybiAwOwotCi1lcnJvcjoK
LQlrZXJuZWxfc29ja19zaHV0ZG93bihsb2NhbC0+c29ja2V0LCBTSFVUX1JEV1IpOwotCWxvY2Fs
LT5zb2NrZXQtPnNrLT5za191c2VyX2RhdGEgPSBOVUxMOwotCXNvY2tfcmVsZWFzZShsb2NhbC0+
c29ja2V0KTsKLQlsb2NhbC0+c29ja2V0ID0gTlVMTDsKLQotCV9sZWF2ZSgiID0gJWQiLCByZXQp
OwotCXJldHVybiByZXQ7CiB9CiAKIC8qCi0tIAoyLjE4LjEKCg==
--000000000000049f2505ba6ed4a3--
